//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

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
    var likes: [Liked] = []
    var refreshView: RefreshView!
    var updatesJSON: JSON = []
    var updatesList: [JSON] = []
    var numberOfUpdates = 0
    var recipientInfoForSegue: JSON = []
    
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
        
        // make the Alamofire API call with completion block, to set the variable updatesJSON in this class
//        Update.retrieveUpdates() { responseObject, error in
        GDService.updatesForNewsfeed() { responseObject, error in
        
            if let value: AnyObject = responseObject {
                let json = JSON(value)
//                print(json)
                self.updatesJSON = json
                self.numberOfUpdates = self.buildUpdates(json["user"]["following"])
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

//        view.showLoading()

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
        
        // need to cast this data to an Update model (from JSON)
        
        var totalUpdates = 0
//        for recipientIndex in 0..<recipients.count {
        // the recipient number could be paginated?
        // otherwise the total amount of updates could be cast and then paginated
        
        // download the whole block and cache, then send 10-part chunks to the cells
            for recipientIndex in 0..<10 {
            totalUpdates += recipients[recipientIndex]["newsfeeds"].count
            
            // extract each item and append it to the array (get all newsfeed items at first, then display what's needed?)
            let newsfeedObjects = recipients[recipientIndex]["newsfeeds"].count
            
            for itemIndex in 0..<newsfeedObjects {
                
                // extract recipient biodata from recipient object
                let displayName = recipients[recipientIndex]["recipient"]["firstName"].string?.capitalizedString ?? ""
                let village = recipients[recipientIndex]["recipient"]["village"].string?.capitalizedString ?? ""
                let biodata = recipients[recipientIndex]["recipient"]
                let userHasLikedUpdate = false
                
                // attach recipient biodata to newsfeed update object
                var newsfeedItem = recipients[recipientIndex]["newsfeeds"][itemIndex]
                newsfeedItem["displayName"] = JSON(displayName)
                newsfeedItem["village"] = JSON(village)
                newsfeedItem["biodata"] = biodata
                newsfeedItem["userHasLikedUpdate"] = JSON(userHasLikedUpdate)
                
                // iterate through photos in recipients["photos"] and return the object
                // in which "type" = "face", to get the recipient's profile image
                // would be a little more efficient as do...while loop maybe
                let photoPath = recipients[recipientIndex]["recipient"]["photos"]
                for photoIndex in 0..<photoPath.count {
//                for photoIndex in 0..<recipients[recipientIndex]["recipient"]["photos"].count {
                    
                    if photoPath[photoIndex]["type"] == "face" {
                        let recipientAvatar = photoPath[photoIndex]["url"].string ?? ""
                        newsfeedItem["recipientAvatar"] = JSON(recipientAvatar)
                    } 
                }
                
                updatesList.append(newsfeedItem)
            }
        }
        
        // sort the finished array of dictionaries by survey date
        updatesList.sortInPlace({$0["surveyDate"] > $1["surveyDate"]})
        
        // cast the updatesList into an array of Update objects
//        updatesList
        
        // return the count of update objects
        return totalUpdates
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return (updates.count)
        //        print(updatesJSON["user"]["following"].count)
        //        return updatesJSON["user"]["following"].count
        
        // this number would probably need to be a range, with an intial value and an append value
        print(updatesList.count)
        return numberOfUpdates
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        // cast to specific class
        if let cell = cell as? UpdateTableViewCell {
            
            // need to pull a single update from a model that may have several
            // 1) extract a single update from model
            // 2) append that update to array
            // 3) once entire array is built, sort by descending
            // 4) send each item to cell via indexPath.row
            
            //            let updateDataForCell: JSON = self.updatesJSON["user"]["following"][indexPath.row]
            let updateDataForCell: JSON = self.updatesList[indexPath.row]
            //
            let user = "admin"
            let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
            let recipientImageURL = self.updatesList[indexPath.row]["recipientAvatar"].string ?? ""
            
            let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            
            let headers = ["Authorization": "Basic \(base64Credentials)"]
            
            //             API call for images
            Alamofire.request(.GET, recipientImageURL, headers: headers).response() {
                (_, _, data, _) in
                
                
                let image = UIImage(data: data!)
                cell.authorImageView.image = image
            }
            
            // configure queued cell with newest data from model
            cell.configureUpdateTableViewCell(updateDataForCell)
            
            cell.delegate = self
        }
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // segue from newsfeed item to recipient profile view
        if segue.identifier == "NewsfeedProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            var recipientInfo = updatesList[indexPath!.item]
            self.matchUpdateWithRecipientGDID(recipientInfo["biodata"]["gdid"].string!)
            print(recipientInfoForSegue)
            toView.recipientInfo = recipientInfoForSegue
        }
        
        // segue from comment to expanded comment view
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as! CommentTableViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            let selectedUpdate = updatesList[indexPath!.item]
            toView.update = selectedUpdate
        }
    }

    // drill through recipient list to find the GDID that matches the update, and retrieve that data
    func matchUpdateWithRecipientGDID(GDID: String) {
        let JSONcount = updatesJSON["user"]["following"].count
        
        for recipientIndex in 0..<JSONcount {
            
            print(updatesJSON["user"]["following"][recipientIndex]["recipient"]["gdid"])
            print(GDID)

            if updatesJSON["user"]["following"][recipientIndex]["recipient"]["gdid"].string == GDID {
                self.recipientInfoForSegue = updatesJSON["user"]["following"][recipientIndex]
                return
            }
        }
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
    
    func recipientImageDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        print("Well, howdy do!")
    }
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        // update the data model with liked status (has liked, increment # of likes)
//        let indexPath = tableView.indexPathForCell(cell)
//        let like = Liked()
//        self.likes[indexPath!.row].toggleLiked()
//        print(likes[indexPath!.row])
        
//        print(indexPath!.row)
//        var update = self.updatesList[indexPath!.row]
        

//        // toggle status of like
//        update["userHasLikedUpdate"] = JSON(!userHasLikedUpdate)
        
//
//        // increment or decrement total likes
//        if update.userHasLikedUpdate {
//            update.numberOfLikes += 1
//        } else {
//            update.numberOfLikes -= 1
//        }
        
        //        // update the view cell
//        cell.configureLikeForCell(update)
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}