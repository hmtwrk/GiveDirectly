//
//  RecipientProfileTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientProfileTableViewController: UITableViewController {
    
    // prepare variable for receiving data from segue
    var recipientInfo: AnyObject = ""
    
    // prepare variable for related Update object
    var numberOfUpdates: Int = 0
    var recipientRelatedUpdateInfo = [AnyObject]()
    var recipientNameData: String = ""
    let identifierList = ["RecipientStats", "RecipientStories", "RelatedUpdateTableViewCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the Parse API call
        self.queryParseForUpdates()
        //        println(recipientInfo)
        
        // set navigation title to match recipient's name
        let recipientName:String? = (recipientInfo as AnyObject)["firstName"] as? String
        self.recipientNameData = recipientName!
        
        // Fill the navigation title with the recipient's name (from Parse query)
        self.navigationItem.title = recipientName
        
        // changing the row height does nothing, but needs to be explicitly set to a value (default = 44)
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // two static cells (stats + stories) with a dynamic number of updates
        return 2 + self.numberOfUpdates
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // need to create third case that takes care of update cells
//        let identifier = indexPath.row == 0 ? "RecipientStats" : "RecipientStories"
//        let identifier = indexPath.row == 0 ? "RecipientStats" : "RelatedUpdateTableViewCell"
        
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
        }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    
    
}

extension RecipientProfileTableViewController {
    
    // Parse query to determine number of update cells to append to the table view, as well as data for the updates
    func queryParseForUpdates() {
        
        let author = (recipientInfo as AnyObject)["gdid"] as! String
        var query:PFQuery = PFQuery(className: "RecipientUpdates")
        query.whereKey("GDID", equalTo: author)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                println(objects!.count)
                self.numberOfUpdates = objects!.count
                self.recipientRelatedUpdateInfo = objects!
                self.tableView?.reloadData()
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
}