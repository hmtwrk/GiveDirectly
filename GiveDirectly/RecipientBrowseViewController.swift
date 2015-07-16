//
//  RecipientBrowseViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/15/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientBrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  
  // TODO: Add pull-down to refresh functionality
  // TODO: Add functionality to hide the navigation bar and bottom bar when scrolling
  // TODO: Add real images from Illustrator and create custom class for round images
  // TODO: Add dummy data featuring text views of different sizes to test dynamic sizing of cells
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // remove seam for custom Navigation Bar
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipientBrowse", forIndexPath: indexPath) as! RecipientBrowseCollectionViewCell
    
    return cell
  }

}
