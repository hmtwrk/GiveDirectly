//
//  RecipientProfileTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientProfileTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    // prepare variable for receiving data from segue
    var recipientInfo: AnyObject = ""
    
    // prepare variable for related Update object
    var numberOfUpdates: Int = 0
    var updates = [Update]()
    var recipientNameData: String = ""
    var likes = [Liked]()
    
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
    
    override func viewDidAppear(animated: Bool) {
        // refresh status of likes
        self.tableView?.reloadData()
    }

    
    // MARK: - Table view data source
    
    // first section holds static info cells, and second section holds related updates
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // section 0 contains the two static cells, whereas section 1 can hold a dynamic amount
        if section == 0 {
            return 2
        } else {
            return updates.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // determine which cell identifier to return
        let identifier: String
        
        // determine which static cell to return for first section
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                // stats cell
                identifier = "RecipientStats"
                
            } else {
                // story cell
                identifier = "RecipientStories"
            }
        } else {
            
            // section 1 for the dynamic number of update cells
            identifier = "UpdateTableViewCell"
            print(identifier)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) 
        
        // configure cells
        if let recipientStatsCell = cell as? RecipientStatsTableViewCell {
            recipientStatsCell.configureStatsCell(recipientInfo)
            
            // load an image (should go in the table controller)
            if let recipientProfilePhoto = recipientInfo["image"] as? PFFile {
                recipientProfilePhoto.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data: imageData!)
                        recipientStatsCell.recipientProfileImageView.image = image
                    }
                }
            } else {
                recipientStatsCell.recipientProfileImageView.image = UIImage(named: "blankProfileImage")
            }
        }
        
        if let recipientStoriesCell = cell as? RecipientStoriesTableViewCell {
            recipientStoriesCell.configureStoriesCell(recipientInfo)
        }
        
        if let recipientUpdatesCell = cell as? UpdateTableViewCell {
            let updateDataForCell:AnyObject = updates[indexPath.row]
            recipientUpdatesCell.configureUpdateTableViewCell(updateDataForCell)
            recipientUpdatesCell.configureLikeForCell(updateDataForCell as! Update)
            recipientUpdatesCell.delegate = self
            
            // this bit is dependent on the includeKey data, and safe if nil
            let recipientData:PFObject? = updateDataForCell["recipientAuthor"] as? PFObject
            
            // following function takes an optional PFObject as a parameter (for update cell)
            ParseHelper.recipientImagesForCell(recipientUpdatesCell, withRecipientData: recipientData, orUpdateData: updateDataForCell)
        }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        print(indexPath.row)
        
        return cell
    }
}


// MARK: Parse API calls
extension RecipientProfileTableViewController {
    
    // TODO: move these delegate actions into own file?
    
    // Parse query to determine number of update cells to append to the table view, as well as data for the updates
    func queryForRelatedUpdates() {
        
        // return the newest updates that correspond to the selected Recipient
        let author = (recipientInfo as AnyObject)["gdid"] as! String
        
        ParseHelper.relatedUpdatesForRecipient(author) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let results = results {
                self.numberOfUpdates = results.count
                print(self.numberOfUpdates)
                self.updates = results as? [Update] ?? []
                
                for update in self.updates {
                    update["userHasLikedUpdate"] = update.userHasLikedUpdate
                }
                
                self.tableView?.reloadData()
                
            } else {
                // log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // incorporate this code into helper and then delete (might use it later)
//    func queryForLikes(updatesQuery: PFQuery) {
//        
//        let likeQuery = Liked.query()
//        likeQuery?.whereKey("likedRecipientUpdate", matchesQuery: updatesQuery)
//        likeQuery?.findObjectsInBackgroundWithBlock {
//            (likes: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                print("\(likes!.count) likes.")
//                self.tableView?.reloadData()
//            } else {
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//    }

    
    
}

extension RecipientProfileTableViewController {
    
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
        for update in updates {
            print(update.userHasLikedUpdate)
        }
        print("==========")
        
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement comment functionality
        
        // open a segue to a comment-entry screen and save results to Parse
        
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, follow?, etc.
    }
    
}
