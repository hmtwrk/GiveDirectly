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
    
    
    // These hardcoded IDs should be replaced by a single Parse query that pulls all the IDs
    let parseObjectIDs = ["ZlFwekZphT", "VN5lcZVRfF", "utMgBL8eh3", "FxCnaPGP7I", "hkVWy6GMUl", "NOpLNXaoz0", "xnKwo4R7Di", "xWgqGbJeFu", "DsaKtF31Ej", "cNXm64TE5X"]
    
    // constants for the colored bars at the bottom of each cell
    let viewOliveColor = UIColor(hex: 0x93AAAF)
    let viewOrangeColor = UIColor(hex: 0xFFBC45)
    let viewCyanColor = UIColor(hex: 0x1EA9DD)
    let viewGreenColor = UIColor(hex: 0x9BCB42)
    let viewBlackColor = UIColor(hex: 0x000000)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // sections are groups of grids—— probably we will only need just one section only
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    // items are individual photos, profiles, views, w/e
    // probably we will need as many items as profiles that exist
    
    // TODO: In the TestClass on Parse, check for how many unique objectId objects exist.
    // Append those IDs into an array and then do an array.count?
    // Answer should be 10.
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // create one row per each recipient ID
        return parseObjectIDs.count
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
        
        // indexPath.row increments for every row that exists
        cell.configureWithBrowseData(parseObjectIDs[indexPath.row])
        
        return cell
    }
    
    
}
