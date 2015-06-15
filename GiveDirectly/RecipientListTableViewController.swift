//
//  ViewController.swift
//  GiveDirectly
//
//  Created by hai tran on 6/10/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts

class RecipientListTableViewController: UITableViewController, RecipientListTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        var biodataQuery:PFQuery = PFQuery(className: "Registration")
        biodataQuery.whereKey("gdid", equalTo: "KE20140318793")
        biodataQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println("retrieved \(objects!.count) things")
                
                for recipientBiodata in objects! {
                    let recipientName:String? = (recipientBiodata as! PFObject)["gdid"] as? String
                    let recipientAge:Int? = (recipientBiodata as! PFObject)["age"] as? Int
                    // let recipientOccupation:String? = (recipientBiodata as! PFObject)[""] as? String
                    // let recipientLocation:String? = (recipientBiodata as! PFObject)[""] as? String
                    let recipientNumberChildren:Int? = (recipientBiodata as! PFObject)["children"] as? Int
                    
                    println(recipientName)
                    println(recipientAge)
                    println(recipientNumberChildren)
                    
                    
                }
                
            } else {
                println("Error: \(error!) \(error!.userInfo)")
            }
            
            

        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipientListCell") as! RecipientListTableViewCell
        
        cell.configureWithParse()
        cell.delegate = self
        
        return cell
    }
    
    
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

