//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class NewsfeedTableViewController: UITableViewController {
    
    // initialize variable to accept Parse update data
    var recipientUpdates = [AnyObject]()
    var numberOfUpdates = Int()
    var mostRecentCommentInfo = [AnyObject]()
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // turn off the seam on the navigation bar for this page only
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        // turn off the cell separators
//        self.tableView.tableFooterView = UIView(frame: CGRectZero)
//        self.tableView.separatorColor = UIColor.clearColor()
        
        
        // autofit cells?
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // query Parse to determine how many updates to display
        self.queryParseForNewsfeedUpdates()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return (numberOfUpdates)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        
        
        // configure cells depending on type
        if let update = cell as? UpdateTableViewCell {
            
            // "updateInfo" is a chunk of the table that populates a row
            let updateInfo: AnyObject = recipientUpdates[indexPath.row]
            
            // "recipientInfo" is a relational lookup on the recipient's name
            let recipientInfo = updateInfo["recipientName"] as? PFObject
            
//            println(recipientInfo!)

            
            
            
            
            // when indexPath.row is finished, reload tableView?
            
            
            
            
            
//            self.queryParseForRelatedComments(updateInfo)
            
            // configure the cell with the comment info
//            update.configureCommentsWithParse(updateInfo)
            
//            self.queryParseForRelatedComments(object)
            
//            let recipientInfo: AnyObject = recipientUpdates[indexPath.row]
            
            update.configureUpdateViewCell(updateInfo, recipientInfo: recipientInfo!)
        }

        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSegue" {
            let toView = segue.destinationViewController as! CommentViewController
            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
            let updateInfo: (AnyObject) = recipientUpdates[indexPath!.row]
            let recipientInfo = updateInfo["recipientName"] as? PFObject

            toView.updateInfo = updateInfo
            toView.recipientInfo = recipientInfo!
        }
    }
    
    
    func queryParseForNewsfeedUpdates() {

        // here is the query for the update text, but need to fetch the "recipientName" pointer,
        // which points to the "Recipients" class, and fetch the data from "name" and "profileSquarePhoto"
        
        var query:PFQuery = PFQuery(className: "RecipientUpdate")
        query.includeKey("recipientName")
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.recipientUpdates = objects!
//                println("Successfully retrieved \(objects!.count) objects!")
                self.numberOfUpdates = objects!.count
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        let query = PFQuery(className: "Comments")
                        query.whereKey("relatedUpdate", equalTo: object)
                        
                        // add constraints to return most recent
                        query.orderByDescending("createdAt")
                        query.limit = 1
                        
                        query.findObjectsInBackgroundWithBlock {
                            
                            (comments: [AnyObject]?, error: NSError?) -> Void in
                            
                            println(comments!)
                            
                        
                        
                        }
                        


//                        println(object.objectId!)
                    }
                
                
                // Parse query is complete, so reload the tableview
                self.tableView?.reloadData()
//                println(self.numberOfUpdatesFromParse)
//                println(self.recipientUpdates)
//                println(query)
                
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            }
        }
    }

    
    
}