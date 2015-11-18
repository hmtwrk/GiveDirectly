
//
//  DynamicLayout.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/11/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class RecipientBrowserViewController: UICollectionViewController, BrowserLayoutDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get JSON data from API
        GDService.profilesForRecipients() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                dynamicRecipientData = json
            }
            
            // strip the user information
            dynamicRecipientData = dynamicRecipientData["user"]["following"]
            
            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        // configure the insets for each collection view item
        collectionView!.contentInset = UIEdgeInsets(top: -5, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! BrowserLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name: "refreshRecipientCollectionView", object: nil)
    }
}

// MARK: Collection View Data Source
extension RecipientBrowserViewController {
    
    func refreshCollection(notification: NSNotification) {
        self.collectionView?.reloadData()
    }
    
    func heightForStory(story: String, font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: story).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dynamicRecipientData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipientBrowserCell", forIndexPath: indexPath) as! BrowserViewCell
        
        let recipientDataForCell = dynamicRecipientData[indexPath.item]["recipient"]
        var recipientImageURL: String!
        let photoPath = dynamicRecipientData[indexPath.item]["recipient"]["photos"]
        
        recipientImageURL = ""
        
        for photoIndex in 0..<photoPath.count {
            
            if photoPath[photoIndex]["type"] == "action" {
                recipientImageURL = photoPath[photoIndex]["url"].string
            }
        }
        
        // download associated image for cell
        GDService.downloadImage(recipientImageURL) { data in
            
            let image = UIImage(data: data)
            cell.profileImageView.image = image
            
        }
        
        cell.configureCellWithData(recipientDataForCell, andRecipientImageURL: recipientImageURL)
        //        cell.profileImageView.imageFromUrl(recipientImageURL)
        //        cell.profileImageView.downloadImage(recipientImageURL)
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecipientProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let recipientInfo = dynamicRecipientData[indexPath!.item]
            print(recipientInfo)
            toView.recipientInfo = recipientInfo
//            toView.recipientImageURL = recipientImageURL
        }
    }
}

extension RecipientBrowserViewController {
    
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        // square photos should have height equal to width
        return width
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        // calculates the size of the text by using the content from spendingPlans
        let annotation = dynamicRecipientData[indexPath.item]["recipient"]["spendingPlans"] ?? ""
        let story = annotation.string ?? ""
        let font = UIFont.systemFontOfSize(14)
        let storyHeight = self.heightForStory(story, font: font, width: width)
        let height = 4 + 17 + 4 + storyHeight + 4
        return height
    }
}