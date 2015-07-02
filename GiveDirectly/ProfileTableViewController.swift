//
//  MulticellTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ProfileTableViewController: UITableViewController {
    
    // prepare variable for receiving data from segue
    var recipientInfo: AnyObject = ""
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // turn the navigation bar seam back on for this page
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.shadowImage = nil
        
        // set navigation title to match recipient's name
        let recipientName:String? = (recipientInfo as AnyObject)["recipientName"] as? String
        

        // test to make sure data was received properly during segue
        println(recipientInfo)
        
        
        // changing the row height does nothing, but needs to be explicitly set to a value (default = 44)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Fill the navigation title with the recipient's name (from Parse query)
        self.navigationItem.title = recipientName
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // One row for the basic profile view, and then a row for each update cell in the Parse backend.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: check query for number of rows needed (number of recipients returned

        
        
        
        
        // just show one profile cell and one update cell, for now
        let numberOfCells = 2
        
        return numberOfCells
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? "ProfileSummaryCell" : "RecipientUpdatesCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        
        
        // configure cells
        if let profileSummaryCell = cell as? ProfileSummaryTableViewCell {
            profileSummaryCell.configureProfileSummary(recipientInfo)
        }
        
        if let recipientUpdatesCell = cell as? RecipientUpdatesTableViewCell {
            recipientUpdatesCell.configureRecipientUpdates(recipientInfo)
        }
        
        // make separators extend all the way left
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    
    // remove the seam when returning to the profile collection view
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    }
    
}
