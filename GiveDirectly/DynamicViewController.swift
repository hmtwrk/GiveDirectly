
//
//  DynamicLayout.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/11/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import AVFoundation

class RecipientBrowserViewController: UICollectionViewController, BrowserLayoutDelegate {
    
    // Uncomment this code when Parse is wired up.
    //    var recipients = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make Parse API call from Recipient class
        Recipient.queryParseForRecipients()
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        let size = CGRectGetWidth(collectionView!.bounds) / 2
        
        // configure the insets for each collection view item
        collectionView!.contentInset = UIEdgeInsets(top: -5, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! BrowserLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name: "refreshRecipientCollectionView", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
//        println(recipientBrowserData)
    }
}

extension RecipientBrowserViewController {
    
    func refreshCollection(notification: NSNotification) {
        self.collectionView?.reloadData()
    }
    
    func heightForStory(story: String, font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: story).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(recipientBrowserData.count)
        return recipientBrowserData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipientBrowserCell", forIndexPath: indexPath) as! BrowserViewCell
        //        cell.configureCellWithParse(recipients[indexPath.item])
        cell.recipient = recipientBrowserData[indexPath.item] as? Recipient
        cell.configureCellWithParse(recipientBrowserData[indexPath.item])
        return cell
    }
}

extension RecipientBrowserViewController: BrowserLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        //        let random = arc4random_uniform(4) + 1
        //        return CGFloat(random * 100)
        
        //            let recipient = recipients[indexPath.item]
        //            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        //            let rect = AVMakeRectWithAspectRatioInsideRect(recipient.image.size, boundingRect)
        //            return rect.height
        
        // square photos should have height equal to width
        return width
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let annotation: (AnyObject) = recipientBrowserData[indexPath.item]
        let story: String? = (annotation as AnyObject)["goals"] as? String
        let font = UIFont(name: "HelveticaNeue", size: 13)!
        
//        println(story!)
        let storyHeight = self.heightForStory(story!, font: font, width: width)
//        let storyHeight = 68
        let height = CGFloat(4 + 17 + 4 + storyHeight + 4)
        return height
    }
    
}