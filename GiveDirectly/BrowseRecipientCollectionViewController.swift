//
//  BrowseRecipientCollectionViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/22/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import QuartzCore



class BrowseRecipientCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // sections are groups of grids—— probably we will only need just the one section
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    // items are individual photos, profiles, views, w/e
    // probably we will need as many items as profiles that exist
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BrowseCells", forIndexPath: indexPath) as! UICollectionViewCell
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
        return cell
    }
    
    
}
