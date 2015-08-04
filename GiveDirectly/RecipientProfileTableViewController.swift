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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation title to match recipient's name
        let recipientName:String? = (recipientInfo as AnyObject)["gdid"] as? String
        println(recipientInfo)
        
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
        
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? "RecipientStats" : "RecipientStories"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        // configure cells
            if let recipientStatsCell = cell as? RecipientStatsTableViewCell {
              recipientStatsCell.configureStatsCell(recipientInfo)
            }
        
            if let recipientStoriesCell = cell as? RecipientStoriesTableViewCell {
              recipientStoriesCell.configureStoriesCell(recipientInfo)
            }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    

    
}
