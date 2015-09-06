//
//  RecipientProfileTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientProfileTableViewController: UITableViewController, RecipientRelatedUpdateCellDelegate {
    
    // prepare variable for receiving data from segue
    var recipientInfo: AnyObject = ""
    
    // prepare variable for related Update object
    var numberOfUpdates: Int = 0
    var recipientRelatedUpdateInfo = [AnyObject]()
    var recipientNameData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the Parse API call
        self.queryForRelatedUpdates()
        
        // set navigation title to match recipient's name
        let recipientName:String? = (recipientInfo as AnyObject)["firstName"] as? String
        self.recipientNameData = recipientName!
        
        // Fill the navigation title with the recipient's name (from Parse query)
        self.navigationItem.title = recipientName
        
        // changing the row height does nothing, but needs to be explicitly set to a value (default = 44)
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // two static cells (stats + stories) with a dynamic number of updates
        return 2 + self.numberOfUpdates
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier: String = ""
        
        if indexPath.row == 0 {
            // stats cell
            identifier = "RecipientStats"
            
        } else if indexPath.row == 1 {
            // story cell
            identifier = "RecipientStories"
            
        } else {
            // update cell
            identifier = "RelatedUpdateTableViewCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        // configure cells
        if let recipientStatsCell = cell as? RecipientStatsTableViewCell {
            recipientStatsCell.configureStatsCell(recipientInfo)
        }
        
        if let recipientStoriesCell = cell as? RecipientStoriesTableViewCell {
            recipientStoriesCell.configureStoriesCell(recipientInfo)
        }
        
        if let recipientUpdateCell = cell as? RecipientRelatedUpdateCell {
            recipientUpdateCell.configureUpdateTableViewCell(recipientNameData, updateData: recipientRelatedUpdateInfo[indexPath.row - 2])
            recipientUpdateCell.delegate = self
        }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        // check to see if there's a cell at the tapped row
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            
//            let item: (AnyObject) = recipientRelatedUpdateInfo[indexPath.row]
////            item.toggleChecked()
//            
//        }
//    }
    
    // MARK: RelatedUpdateCellDelegate
    func relatedUpdateCellLikeButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject) {
        // hello
        println("Like button has been tapped!")
    }
    
    func relatedUpdateCellCommentButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject) {
        // hi
        println("Comment button has been tapped!")
    }
    
    func relatedUpdateCellExtraButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject) {
        // another
        println("Extra button has been tapped!")
    }
}


// MARK: Parse API call
extension RecipientProfileTableViewController {
    
    // Parse query to determine number of update cells to append to the table view, as well as data for the updates
    func queryForRelatedUpdates() {
        
        // return the 20 newest updates that correspond to the selected Recipient, arranged in descending order
        let author = (recipientInfo as AnyObject)["gdid"] as! String
        var query:PFQuery = PFQuery(className: "RecipientUpdates")
        query.whereKey("GDID", equalTo: author)
        query.orderByDescending("createdAt")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (updates: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
//                println(updates!)
                println("\(updates!.count) updates.")
                self.numberOfUpdates = updates!.count
                self.recipientRelatedUpdateInfo = updates!
                
                // make API call to determine which updates are liked by currentUser, and total number of likes
                self.queryForLikes(query)
                
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func queryForLikes(updatesQuery: PFQuery) {
        
        // let currentUser = PFUser (assign a constant to the currentUser)
        var likedQuery: PFQuery = PFQuery(className: "Liked")
        likedQuery.whereKey("likedRecipientUpdate", matchesQuery: updatesQuery)
        likedQuery.findObjectsInBackgroundWithBlock {
            (likes: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // check how many likes exist
                println("\(likes!.count) likes.")
//                println(likes!)
                
                // tableView is reloaded after the final Parse API call is completed
                self.tableView?.reloadData()
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
}
