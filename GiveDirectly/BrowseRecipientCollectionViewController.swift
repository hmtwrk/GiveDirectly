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

// necessary?
import AVFoundation


class BrowseRecipientCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // determine whether or not to display a loading screen
    var isFirstTime = true

    // initialize variable for Parse recipient data array
    var recipientData = [AnyObject]()
    
    
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
    
    
    // only going to need one section only?
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipientData.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BrowseCell", forIndexPath: indexPath) as! BrowseRecipientCollectionViewCell
        
        // set up the appearance of the cells
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.lightGrayColor().CGColor

        
        // cycle through colors
//        cell.coloredBarView.backgroundColor = barViewColor[indexPath.row % barViewColor.count]
//      
      
        // the recipientData object is being sent OK, but need to constrain info for each ID
        let recipientInfo: AnyObject = recipientData[indexPath.row]
        
        cell.configureCellWithParse(recipientInfo)
        
        // cell.configureProfileImage()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecipientProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let recipientInfo: (AnyObject) = recipientData[indexPath!.row]
            toView.recipientInfo = recipientInfo
            //            println(recipientInfo)
        }
    }

    // This function will do the Parse query, and then return appropriate objects for use in building each item's cell
    func queryForRecipientData() {
        var query:PFQuery = PFQuery(className: "Registration")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                
                // need to mine this variable to return just one ID information
                self.recipientData = objects!
                
//                println("Successfully retrieved \(objects!.count) objects!")

                
                // Parse query is complete, so reload the collection view
                self.collectionView?.reloadData()
                
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout delegate method
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSpacing = CGFloat(15)        // define the space between each cell
        let leftRightMargin = CGFloat(15)   // if defined in IB for "section insets"
        let numColumns = CGFloat(2)         // the total number of columns you want
        
        let totalCellSpace = cellSpacing * (numColumns - 1)                             // calculates the total (empty) space in view
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns       // seems OK
        let height = CGFloat(250)           // whatever height you want
        
        return CGSizeMake(width, height)

    }
    
    
}
