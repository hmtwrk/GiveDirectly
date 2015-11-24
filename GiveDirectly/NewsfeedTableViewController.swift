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

// TODO: Some kind of "handle refresh" function?

// leftover code from demo, which might be useful (delay for pull-to-refresh)
func delayBySeconds(seconds: Double, delayedCode: ()->() ) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}

class NewsfeedTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    // property list
    var recipients = [Recipient]()
    var updates: [Update] = []
    var refreshView: RefreshView!
    var recipientInfoForSegue: JSON = []
    var isFirstTime = true
    
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
        
        // TODO: migrate app's initial API calls (recipients, first 10 updates) to appDelegate
        GDService.updatesForNewsfeed() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                var json = JSON(value)
                json = json["newsfeeds"]
                print(json)
                
                for updateIndex in 0..<json.count {
                    
                    let update = Update()
                    let path = json[updateIndex]
                    
                    // retrieve related model data from API call results
                    let photoURL = path["avatar_url"].string ?? ""
                    let firstName = path["firstName"].string ?? ""
                    let lastName = path["lastName"].string ?? ""
                    let text = path["update"].string ?? ""
                    let date = path["date"].string ?? ""
                    let numberOfLikes = path["likes"].int ?? 0
                    let numberOfComments = path["comments"].int ?? 0
                    let isFlagged = path["isFlagged"].bool ?? false
                    let gdid = path["gdid"].string ?? ""
                    let fromGD = path["from_gd"].bool ?? false
                    let isPinned = path["pinned"].bool ?? false
                    
                    // assign data to model variables
                    update.profileImageURL = photoURL
                    update.recipientFirstName = firstName
                    update.recipientLastName = lastName
                    update.text = text
                    update.date = date
                    update.numberOfLikes = numberOfLikes
                    update.numberOfComments = numberOfComments
                    update.isFlagged = isFlagged
                    update.gdid = gdid
                    update.fromGD = fromGD
                    update.isPinned = isPinned
                    
                    // append model to array
                    self.updates.append(update)
                    
                }
            }
            
            
            // both models are mapped, insert additional code here for completion
            // use the results of the GDID matching to assign the remaining properties:
            // update.profileImageURL
            // update.recipientDisplayName
            
            
            //                        self.testPrintRecipientWithIndex(8)
            //                        print("======================")
            //                        self.testPrintUpdateWithIndex(8)
            self.tableView?.reloadData()
        }
    }
    
    func testPrintUpdateWithIndex(index: Int) {
        
        // print property values of updates
        print(self.updates[index].text)
        print(self.updates[index].date)
        print(self.updates[index].numberOfLikes)
        print(self.updates[index].numberOfComments)
        print(self.updates[index].isFlagged)
        print(self.updates[index].gdid)
    }
    
    func testPrintRecipientWithIndex(index: Int) {
        
        // print property values of recipients
        print(self.recipients[index].gdid)
        print(self.recipients[index].firstName)
        print(self.recipients[index].lastName)
        print(self.recipients[index].age)
        print(self.recipients[index].gender)
        print(self.recipients[index].maritalStatus)
        print(self.recipients[index].numberOfChildren)
        print(self.recipients[index].paymentPhase)
        print(self.recipients[index].village)
        print(self.recipients[index].spendingPlans)
        print(self.recipients[index].goals)
        print(self.recipients[index].achievements)
        print(self.recipients[index].challenges)
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.updates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        // cast to specific class
        if let cell = cell as? UpdateTableViewCell {
            
            let update = self.updates[indexPath.row]
            update.downloadImage()
            cell.update = update
            
            //            let recipientImageURL = self.updates[indexPath.row].profileImageURL
            
            // download associated image for cell (seems this has to go here)
            //            GDService.downloadImage(recipientImageURL) { data in
            //
            //                let image = UIImage(data: data)
            //                cell.authorImageView.image = image
            //
            //            }
            
            // configure queued cell with newest data from model
            //            cell.authorImageView.image = update.avatarImage
            cell.configureUpdateTableViewCell(update)
            cell.delegate = self
        }
        return cell
    }
    
    
    
    // trigger the next API call (when indexPath.row reaches a certain value)
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // use this code to keep from triggering upon initialization
        if indexPath.row + 3 == self.updates.count {
            
            if isFirstTime == false {
                print("The count is this much: \(self.updates.count).")
                print("And indexPath.row is this much: \(indexPath.row).")
                
                // TODO: clean up all this redundant code and pack into a function
                GDService.updatesForNewsfeedScrolling(self.updates.count) { responseObject, error in
                    
                    if let value: AnyObject = responseObject {
                        var json = JSON(value)
                        json = json["newsfeeds"]
                        
                        for updateIndex in 0..<json.count {
                            
                            let update = Update()
                            let path = json[updateIndex]
                            
                            // retrieve related model data from API call results
                            let photoURL = path["avatar_url"].string ?? ""
                            let firstName = path["firstName"].string ?? ""
                            let lastName = path["lastName"].string ?? ""
                            let text = path["update"].string ?? ""
                            let date = path["date"].string ?? ""
                            let numberOfLikes = path["likes"].int ?? 0
                            let numberOfComments = path["comments"].int ?? 0
                            let isFlagged = path["isFlagged"].bool ?? false
                            let gdid = path["gdid"].string ?? ""
                            let fromGD = path["from_gd"].bool ?? false
                            let isPinned = path["pinned"].bool ?? false
                            
                            // assign data to model variables
                            update.profileImageURL = photoURL
                            update.recipientFirstName = firstName
                            update.recipientLastName = lastName
                            update.text = text
                            update.date = date
                            update.numberOfLikes = numberOfLikes
                            update.numberOfComments = numberOfComments
                            update.isFlagged = isFlagged
                            update.gdid = gdid
                            update.fromGD = fromGD
                            update.isPinned = isPinned
                            
                            // append model to array
                            self.updates.append(update)
                            
                        }

                    }
                    
                    
                    
                    // refresh the view
                    self.tableView?.reloadData()
                }
            }
            
            isFirstTime = false
            
        }
        
    } // here?
    
    
    
    // TODO: if possible, configure the segue to move from Newsfeed to Recipients > Profile View, when the recipient's avatar image is tapped
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // segue from newsfeed item to recipient profile view
        if segue.identifier == "NewsfeedProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            let recipient = updates[indexPath!.item].relatedRecipient
            toView.recipient = recipient
        }
        
        // segue from comment to expanded comment view
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as! CommentTableViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            let update = updates[indexPath!.item]
            toView.update = update
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
        performSegueWithIdentifier("NewsfeedProfileSegue", sender: cell)
    }
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}