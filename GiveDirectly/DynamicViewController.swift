
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make Parse API call from Recipient class
        //        Recipient.queryParseForRecipients()
        
        // get JSON data from API
        User.retrieveUser() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                dynamicRecipientData = json
            }
            
//            print(dynamicRecipientData)
            
            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
        
        // 1) retrieve the user object, extract the 50 followed recipients
        // 2) use the extracted data similarly to what is being done now
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        _ = CGRectGetWidth(collectionView!.bounds) / 2
        
        // configure the insets for each collection view item
        collectionView!.contentInset = UIEdgeInsets(top: -5, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! BrowserLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name: "refreshRecipientCollectionView", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}

// MARK: Collection View Data Source
extension RecipientBrowserViewController {
    
    func refreshCollection(notification: NSNotification) {
        //        print("Reload activated.")
        self.collectionView?.reloadData()
        //        print(dynamicRecipientData["recipients"].count)
    }
    
    func heightForStory(story: String, font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: story).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print(recipientBrowserData.count)
        //        return recipientBrowserData.count
        //        print("There are \(dynamicRecipientData.count) items in the section.")
        //        return dynamicRecipientData.count
        return dynamicRecipientData["user"]["following"].count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipientBrowserCell", forIndexPath: indexPath) as! BrowserViewCell
        //        cell.configureCellWithParse(recipients[indexPath.item])
        
        
        //        let recipientDataForCell = recipientBrowserData[indexPath.item]
        let recipientDataForCell = dynamicRecipientData["user"]["following"][indexPath.item]
        //        let JSONindex = dynamicRecipientData.count
        //        print("The index is: \(JSONindex).")
        
        // TODO: check this out... is this even needed anymore?
        //        cell.recipient = recipientDataForCell as? Recipient
        
        // load an image
        //        if let recipientProfilePhoto = recipientDataForCell["image"] as? PFFile {
        //            recipientProfilePhoto.getDataInBackgroundWithBlock {
        //                (imageData: NSData?, error: NSError?) -> Void in
        //                if (error == nil) {
        //                    let image = UIImage(data: imageData!)
        //                    cell.profileImageView.image = image
        //                } else {
        //                    // there was an error
        //                    print("There was an error of \(error).")
        //                }
        //            }
        //        } else {
        //            cell.profileImageView.image = UIImage(named: "blankProfileImage")
        //        }
        
        
        //        cell.configureCellWithParse(recipientDataForCell)
        cell.configureCellWithData(recipientDataForCell)
        //        print(indexPath.item)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecipientProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let recipientInfo = dynamicRecipientData["user"]["following"][indexPath!.item]
            toView.recipientInfo = recipientInfo
        }
    }
}

extension RecipientBrowserViewController {
    
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
        
        // calculates the size of the text by using the content from spendingPlans
        let annotation = dynamicRecipientData["user"]["following"][indexPath.item]["spendingPlans"]
        //        print("Annotation is:\(annotation).")
        
        let story = annotation.string
        let font = UIFont.systemFontOfSize(14)
        let storyHeight = self.heightForStory(story!, font: font, width: width)
        //        let storyHeight = 68//        let height = CGFloat(4 + 17 + 4 + storyHeight + 4)
        let height = 4 + 17 + 4 + storyHeight + 4
        return height
    }
    
    
}