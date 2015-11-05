//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

private let refreshViewHeight: CGFloat = 200

// leftover code from demo, which might be useful (delay for pull-to-refresh)
func delayBySeconds(seconds: Double, delayedCode: ()->() ) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}

class NewsfeedTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    var updates: [Update] = []
    var refreshView: RefreshView!
    var updatesJSON: JSON = []
    var updatesList: [JSON] = []
    var numberOfUpdates = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull-to-refresh code
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(view.bounds), height: refreshViewHeight), scrollView: tableView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.delegate = self
        view.insertSubview(refreshView, atIndex: 0)
        
        // turn off the seam on the navigation bar for this page only
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        // autofit cells
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // just testing
//        Recipient.testUsersFilter()

        
        // make the Alamofire API call with completion block, to set the variable updatesJSON in this class
        Update.retrieveUpdates() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                self.updatesJSON = json
                self.numberOfUpdates = self.buildUpdates(json["user"]["following"])
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView?.reloadData()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

// MARK: - Table View Data Source
extension NewsfeedTableViewController {
    
    // iterate through the recipients "newsfeeds" and count the items within
    func buildUpdates(recipients: JSON) -> Int {
        var totalUpdates = 0
        for recipientIndex in 0..<recipients.count {
            totalUpdates += recipients[recipientIndex]["newsfeeds"].count
            
            // extract each item and append it to the array
            let newsfeedObjects = recipients[recipientIndex]["newsfeeds"].count
            
            for itemIndex in 0..<newsfeedObjects {
                
                // extract recipient biodata from recipient object
                let displayName = recipients[recipientIndex]["firstName"].string?.capitalizedString ?? ""
                let village = recipients[recipientIndex]["village"].string?.capitalizedString ?? ""
                
                // attach recipient biodata to newsfeed update object
                var newsfeedItem = recipients[recipientIndex]["newsfeeds"][itemIndex]
                newsfeedItem["displayName"] = JSON(displayName)
                newsfeedItem["village"] = JSON(village)

                // iterate through photos in recipients["photos"] and return the object
                // in which "type" = "face", to get the recipient's profile image
                for photoIndex in 0..<recipients[recipientIndex]["photos"].count {
                    
                    if recipients[recipientIndex]["photos"][photoIndex]["type"] == "face" {
                        let recipientAvatar = recipients[recipientIndex]["photos"][photoIndex]["url"].string ?? ""
                        newsfeedItem["recipientAvatar"] = JSON(recipientAvatar)
                    }
                }
                
                updatesList.append(newsfeedItem)
            }
        }
        
//        print(recipients[0])
//        print(updatesList[0])
        
        // sort the finished array of dictionaries by survey date
        updatesList.sortInPlace({$0["surveyDate"] > $1["surveyDate"]})

        // return the count of update objects
        return totalUpdates
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return (updates.count)
        //        print(updatesJSON["user"]["following"].count)
        //        return updatesJSON["user"]["following"].count
        return numberOfUpdates
    }
    
    // tableView:cellForRowAtIndexPath gets called every time a cell is queued,
    // so the functions inside need to update the cell with the most current
    // data from the model (configureLike, etc)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        // cast to specific class
        if let cell = cell as? UpdateTableViewCell {
            
            // need to pull a single update from a model that may have several
            // 1) extract a single update from model
            // 2) append that update to array
            // 3) once entire array is built, sort by descending
            // 4) send each item to cell via indexPath.row
            
//            let updateDataForCell: JSON = self.updatesJSON["user"]["following"][indexPath.row]
            let updateDataForCell: JSON = self.updatesList[indexPath.row]
            
            // configure queued cell with newest data from model
            cell.configureUpdateTableViewCell(updateDataForCell)

            cell.delegate = self
        }
        return cell!
    }
}

extension NewsfeedTableViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(1.5) {
            self.refreshView.endRefreshing()
            
            // TODO: make an Alamofire refresh with completion block
        }
    }
}

// MARK: UpdateTableViewCellDelegate
extension NewsfeedTableViewController {
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        // update the data model with liked status (has liked, increment # of likes)
        let indexPath = tableView.indexPathForCell(cell)
        let update = updates[indexPath!.row]
        
        // toggle status of like
        update.userHasLikedUpdate = !update.userHasLikedUpdate
        
        // increment or decrement total likes
        if update.userHasLikedUpdate {
            update.numberOfLikes += 1
            
            // call Parse function to like update
            ParseHelper.likeUpdate(PFUser.currentUser()!, update: update)
            
        } else {
            update.numberOfLikes -= 1
            
            // call Parse to unlike update
            ParseHelper.unlikeUpdate(PFUser.currentUser()!, update: update)
        }
        
        // update the view cell
        cell.configureLikeForCell(update)
        
        // display status of data model in console (for testing)
        //        for update in updates {
        //            print(update.userHasLikedUpdate)
        //        }
        //        print("==========")
        
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement comment functionality
        // needs to have the row and etc.
        
        
        // create a Comment object with the user's objectId
        // that points to the update (author to relatedUpdate with text)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}