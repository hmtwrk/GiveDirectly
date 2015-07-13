//
//  BrowseRecipientCollectionViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/22/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import QuartzCore
import Parse
import Bolts


class BrowseRecipientCollectionViewController: UICollectionViewController {
    

    // determine whether or not to display a loading screen
    var isFirstTime = true
    
    // initalize variable for recipient ID array
    var objectIDsFromParse = [String]()
    
    // initialize variable for Parse recipient data array
    var recipientData = [AnyObject]()
    
    
    // constants for the colored bars at the bottom of each cell
    let viewOliveColor = UIColor(hex: "#93AAAF")
    let viewOrangeColor = UIColor(hex: "#FFBC45")
    let viewCyanColor = UIColor(hex: "#1EA9DD")
    let viewGreenColor = UIColor(hex: "#9BCB42")
    let viewBlackColor = UIColor(hex: "#000000")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.queryForRecipientData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // turn off the seam on the navigation bar for this page only
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        if isFirstTime {
            
            // TODO: call a function to display a loading screen
            
            // switch flag
            isFirstTime = false
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // sections are groups of grids—— probably we will only need just one section only
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // create one row per each recipient ID
        return objectIDsFromParse.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BrowseCells", forIndexPath: indexPath) as! BrowseRecipientCollectionViewCell
        
        // set up the appearance of the cells
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        // array of repeating colors for colored UIView at the bottom of each cell
        let barViewColor = [
            
            viewOliveColor,
            viewOrangeColor,
            viewCyanColor,
            viewGreenColor,
            viewBlackColor
            
        ]
        
        // cycle through colors
        cell.coloredBarView.backgroundColor = barViewColor[indexPath.row % barViewColor.count]
        
        // the recipientData object is being sent OK, but need to constrain info for each ID
        let recipientInfo: AnyObject = recipientData[indexPath.row]
        
        cell.configureCellWithParse(recipientInfo)
        
        // cell.configureProfileImage()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProfileSegue" {
            let toView = segue.destinationViewController as! ProfileTableViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let recipientInfo: (AnyObject) = recipientData[indexPath!.row]
            toView.recipientInfo = recipientInfo
//            println(recipientInfo)
        }
    }

    // This function will do the Parse query, and then return appropriate objects for use in building each item's cell
    func queryForRecipientData() {
        var query:PFQuery = PFQuery(className: "Recipients")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                
                // need to mine this variable to return just one ID information
                self.recipientData = objects!
                
                println("Successfully retrieved \(objects!.count) objects!")

                
                // casting AnyObject to PFObject to use "objectId" subclass
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        // builds array of recipient IDs for determining number of items to display
                        self.objectIDsFromParse.append(object.objectId!)
                        
                        // testing function
                        println(object.objectId!)
                        
                    }
                    
                }
                
                // Parse query is complete, so reload the collection view
                self.collectionView?.reloadData()
                println(self.objectIDsFromParse)
                
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    
    
}
