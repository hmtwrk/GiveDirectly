//
//  RecipientProfileTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

class RecipientProfileTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    // property list
    var recipient = Recipient()
    var updates = [Update]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fill the navigation title with the recipient's name
        recipient.displayName = recipient.firstName
        self.navigationItem.title = recipient.displayName
        
        // changing the row height does nothing, but needs to be explicitly set to a value (default = 44)
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.fetchUpdates()
    }
    
    override func viewDidAppear(animated: Bool) {
        // refresh status of likes
//        self.tableView?.reloadData()
    }

    
    // MARK: - Table view data source
    
    // first section holds static info cells, and second section holds related updates
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // section 0 contains two static cells, whereas section 1 holds a dynamic amount
        if section == 0 {
            return 2
        } else {
            // TODO: make an API call for all the newsfeeds from this recipient
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

        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) 
        
        // configure cells
        if let recipientStatsCell = cell as? RecipientStatsTableViewCell {
            recipientStatsCell.configureStatsCell(self.recipient)
            
            // download associated image for cell
//            GDService.downloadImage(self.recipient.avatarURL) { data in
//                
//                let image = UIImage(data: data)
//                recipientStatsCell.recipientProfileImageView.image = image
//                
//            }
            
        }
        
        if let recipientStoriesCell = cell as? RecipientStoriesTableViewCell {
            
            recipientStoriesCell.configureStoriesCell(self.recipient)
            
        }
        
        if let recipientUpdatesCell = cell as? UpdateTableViewCell {

            // API call for image
//            GDService.downloadImage(recipient.avatarURL) { data in
//             
//                let image = UIImage(data: data)
//                recipientUpdatesCell.authorImageView.image = image
//                
//            }

            let update = updates[indexPath.row]
            recipientUpdatesCell.configureUpdateTableViewCell(update)
            recipientUpdatesCell.delegate = self
        }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
//        print(indexPath.row)
        
        return cell
    }
}


extension RecipientProfileTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // segue from comment to expanded comment view
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as! CommentTableViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            let update = self.updates[indexPath!.item]
            toView.update = update
        }
    }
    
    func fetchUpdates() {
        
        // TODO: make a unique API call that fetches all updates related to this recipient
        // Possible to make an API call that is filtered to just one GDID?
        
    }
    
    func recipientImageDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // default action would be to segue to this very view, so no action required
        print("Well, I'll be danged!")
    }
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        // update the data model with liked status (has liked, increment # of likes)
//        let indexPath = tableView.indexPathForCell(cell)
//        let update = updates[indexPath!.row]
        
        // toggle status of like
//        update.userHasLikedUpdate = !update.userHasLikedUpdate
        
        // increment or decrement total likes
//        if update.userHasLikedUpdate {
//            update.numberOfLikes += 1
//        } else {
//            update.numberOfLikes -= 1
//        }
        
        // update the view cell
//        cell.configureLikeForCell(update)

        
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement comment functionality
        
        // open a segue to a comment-entry screen and save results to Parse
        performSegueWithIdentifier("CommentsSegue", sender: cell)
        
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, follow?, etc.
    }
    
}
