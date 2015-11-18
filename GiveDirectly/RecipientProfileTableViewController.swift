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
    
    // prepare variable for receiving data from segue
//    var recipientInfo: AnyObject = ""
    var recipientInfo: JSON = ""
    var updatesInfo: [JSON] = []
    var updatesList: [JSON] = []

    
    // prepare variable for related Update object
    var numberOfUpdates: Int = 0
    var updates = [Update]()
    var recipientNameData: String = ""
    var likes = [Liked]()
    var recipientImageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation title to match recipient's name
        let recipientName = recipientInfo["recipient"]["firstName"].string ?? ""
        self.recipientNameData = recipientName
        
        // Fill the navigation title with the recipient's name
        self.navigationItem.title = recipientName
        
        // changing the row height does nothing, but needs to be explicitly set to a value (default = 44)
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // find the profile image
        let photoPath = recipientInfo["recipient"]["photos"]
        for photoIndex in 0..<photoPath.count {
            
            if photoPath[photoIndex]["type"] == "face" {
                recipientImageURL = photoPath[photoIndex]["url"].string ?? ""
            }
        }
        
        self.buildUpdates()
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
            return recipientInfo["newsfeeds"].count
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
//            recipientStatsCell.configureStatsCell(recipientInfo["recipient"])
            recipientStatsCell.configureStatsCell(recipientInfo["recipient"])
            
            // Alamofire stuff
            let user = "admin"
            let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
            let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            
            let headers = ["Authorization": "Basic \(base64Credentials)"]
            
            // API call
            Alamofire.request(.GET, recipientImageURL, headers: headers).response() {
                (_, _, data, _) in
                
                
                let image = UIImage(data: data!)
                recipientStatsCell.recipientProfileImageView.image = image
                
            }
            
        }
        
        if let recipientStoriesCell = cell as? RecipientStoriesTableViewCell {
            recipientStoriesCell.configureStoriesCell(recipientInfo["recipient"])
        }
        
        if let recipientUpdatesCell = cell as? UpdateTableViewCell {
            

//            let recipientImageURL = self.updatesList[indexPath.row]["recipientAvatar"].string ?? ""
            
            // Alamofire stuff
            let user = "admin"
            let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
            let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            
            let headers = ["Authorization": "Basic \(base64Credentials)"]
            
            // API call
            Alamofire.request(.GET, recipientImageURL, headers: headers).response() {
                (_, _, data, _) in
                
                
                let image = UIImage(data: data!)
                recipientUpdatesCell.authorImageView.image = image

            }
            
            let updateDataForCell = updatesList[indexPath.row]
            recipientUpdatesCell.configureUpdateTableViewCell(updateDataForCell)
//            recipientUpdatesCell.configureLikeForCell(updateDataForCell as! Update)
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
            let selectedUpdate = updatesList[indexPath!.item]
            toView.update = selectedUpdate
        }
    }
    
    func buildUpdates() {
        
        // extract biodata from recipient object
        let displayName = recipientInfo["recipient"]["firstName"].string?.capitalizedString ?? ""
        let village = recipientInfo["recipient"]["village"].string?.capitalizedString ?? ""
        
        // iterate through newsfeed items
        for itemIndex in 0..<recipientInfo["newsfeeds"].count {
            
            // attach biodata to update object
            var newsfeedItem = recipientInfo["newsfeeds"][itemIndex]
            newsfeedItem["displayName"] = JSON(displayName)
            newsfeedItem["village"] = JSON(village)
            
            // append the newsfeed updates list
            updatesList.append(newsfeedItem)
        }
        
        // sort the finished array of dictionaries by survey date
        updatesList.sortInPlace({$0["surveyDate"] > $1["surveyDate"]})
        

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
