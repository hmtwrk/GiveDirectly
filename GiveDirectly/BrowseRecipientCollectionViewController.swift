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
    
    // These hardcoded IDs should be replaced by a single Parse query that pulls all the IDs and fills an array with them
    
        let parseObjectIDs = ["ZlFwekZphT", "VN5lcZVRfF", "utMgBL8eh3", "FxCnaPGP7I", "hkVWy6GMUl", "NOpLNXaoz0", "xnKwo4R7Di", "xWgqGbJeFu", "DsaKtF31Ej", "cNXm64TE5X"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        // self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // sections are groups of grids—— probably we will only need just the one section only
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    // items are individual photos, profiles, views, w/e
    // probably we will need as many items as profiles that exist
    
    // In the TestClass on Parse, check for how many unique objectId objects exist.
    // Append those IDs into an array and then do an array.count?
    // Answer should be 10.
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parseObjectIDs.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BrowseCells", forIndexPath: indexPath) as! BrowseRecipientCollectionViewCell
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        // TODO: create array for color bar
        
        // indexPath.row increments for every row that exists
        cell.configureWithBrowseData(parseObjectIDs[indexPath.row])
        
        return cell
    }
    
    
}
