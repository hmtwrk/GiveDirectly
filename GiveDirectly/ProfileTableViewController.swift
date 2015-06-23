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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Why doesn't this code below seem to seem to do anything?
         tableView.estimatedRowHeight = 300
         tableView.rowHeight = UITableViewAutomaticDimension
        
        queryParseForRows()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Table view data source
    
    // One row for the basic profile view, and then a row for each update cell in the Parse backend.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: create a query that counts the number of updates to return,
        // and then return the number of updates plus the one cell for the profile cell
        // (So if there are five updates, the function would return "6")
        

        
        let numberOfCells = 1
        
        return numberOfCells
    }
    
    
    // Controller determining which cell(s) to plug into the table view... how to return multiple?
    // Where to do the Parse query?
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        
        
        
        let identifier = "RecipientUpdatesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! RecipientUpdatesTableViewCell
        
        
        // let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.configureRecipientUpdates()
        // cell.configureProfileSummary()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    func queryParseForRows() {
        
        let numberOfUpdates:PFQuery = PFQuery(className: "RecipientUpdate")
        numberOfUpdates.whereKey("recipientName", equalTo: PFObject (withoutDataWithClassName: "recipientName", objectId: "st3hctPPFb"))
        numberOfUpdates.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println("retrieved \(objects!.count) things")
                
//                
//                [query whereKey:@"post"
//                equalTo:[PFObject objectWithoutDataWithClassName:@"Post" objectId:@"1zEcyElZ80"]];
                
//                for recipientBiodata in objects! {
//                    let recipientName:String? = (recipientBiodata as! PFObject)["name"] as? String
//                    let recipientAge:Int? = (recipientBiodata as! PFObject)["age"] as? Int
//                    let recipientOccupation:String? = (recipientBiodata as! PFObject)["job"] as? String
//                    let recipientLocation:String? = (recipientBiodata as! PFObject)["location"] as? String
//                    let recipientNumberChildren:Int? = (recipientBiodata as! PFObject)["children"] as? Int
//                    
//                    println(recipientName)
//                    println(recipientAge)
//                    println(recipientNumberChildren)
//                
//                    
//                }
                
            } else {
                println("Error: \(error!) \(error!.userInfo)")
            }
            
            
            
        }
        
    }
    
    
    
    
}
