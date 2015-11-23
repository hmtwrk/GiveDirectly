
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
    
    // property list
    var recipients = [Recipient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get JSON data from API
        GDService.profilesForRecipientsView() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                var json = JSON(value)
                json = json["recipients"]
                
                // iterate through each JSON entry and map the results to the local model
                for recipientIndex in 0..<json.count {
                    
                    let recipient = Recipient()
                    let path = json[recipientIndex]["recipient"]
                    
                    // retrieve related model data from API call results
                    let gdid = path["gdid"].string ?? ""
                    let firstName = path["firstName"].string?.capitalizedString ?? ""
                    let lastName = path["lastName"].string?.capitalizedString ?? ""
                    let age = path["age"].int ?? 0
                    let gender = path["gender"].string ?? ""
                    let maritalStatus = path["maritalStatus"].string ?? ""
                    let numberOfChildren = path["numberOfChildren"].int ?? 0
                    let phase = path["phase"].string ?? ""
                    let village = path["village"].string?.capitalizedString ?? ""
                    
                    let spendingPlans = path["spendingPlans"].string ?? ""
                    let goals = path["goals"].string ?? ""
                    let achievements = path["achievements"].string ?? ""
                    let challenges = path["challenges"].string ?? ""
                    
                    
                    // assign data to model variables
                    recipient.gdid = gdid
                    recipient.firstName = firstName
                    recipient.lastName = lastName
                    recipient.age = age
                    recipient.gender = gender
                    recipient.maritalStatus = maritalStatus
                    recipient.numberOfChildren = numberOfChildren
                    recipient.paymentPhase = phase
                    recipient.village = village
                    
                    recipient.spendingPlans = spendingPlans
                    recipient.goals = goals
                    recipient.achievements = achievements
                    recipient.challenges = challenges
                    
                    
                    // extract photo URLs from internal array
                    for photoIndex in 0..<path["photos"].count {
                        
                        if path["photos"][photoIndex]["type"] == "family" {
                            recipient.actionURL = path["photos"][photoIndex]["url"].string ?? ""
                        }
                        
                        if path["photos"][photoIndex]["type"] == "face" {
                            recipient.avatarURL = path["photos"][photoIndex]["url"].string ?? ""
                        }
                    }
                    
                    // seems to be better performance when download starts earlier
//                    GDService.downloadImage(recipient.actionURL) { data in
//                        
//                        let image = UIImage(data: data)
//                        recipient.actionImage = image
//                        
//                    }
                    
                    // append model to array
                    self.recipients.append(recipient)
                    
                }
            }
            
            //            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
            
//            print(self.recipients[3].firstName)
            
            self.collectionView?.reloadData()
            
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
        
        print("Here are the number of recipients to display:")
        print(self.recipients.count)
        return self.recipients.count
    }
    
    // detect whether user has scrolled to bottom of cells, and if needs to trigger an API call
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item + 1 == self.recipients.count {
            print("We gonna need more recipients!")
            
            GDService.profilesForRecipientsViewScrolling(self.recipients.count) { responseObject, error in
                
                if let value: AnyObject = responseObject {
                    var json = JSON(value)
                    json = json["recipients"]
                    
                    // iterate through each JSON entry and map the results to the local model
                    for recipientIndex in 0..<json.count {
                        
                        let recipient = Recipient()
                        let path = json[recipientIndex]["recipient"]
                        
                        // retrieve related model data from API call results
                        let gdid = path["gdid"].string ?? ""
                        let firstName = path["firstName"].string?.capitalizedString ?? ""
                        let lastName = path["lastName"].string?.capitalizedString ?? ""
                        let age = path["age"].int ?? 0
                        let gender = path["gender"].string ?? ""
                        let maritalStatus = path["maritalStatus"].string ?? ""
                        let numberOfChildren = path["numberOfChildren"].int ?? 0
                        let phase = path["phase"].string ?? ""
                        let village = path["village"].string?.capitalizedString ?? ""
                        
                        let spendingPlans = path["spendingPlans"].string ?? ""
                        let goals = path["goals"].string ?? ""
                        let achievements = path["achievements"].string ?? ""
                        let challenges = path["challenges"].string ?? ""
                        
                        
                        // assign data to model variables
                        recipient.gdid = gdid
                        recipient.firstName = firstName
                        recipient.lastName = lastName
                        recipient.age = age
                        recipient.gender = gender
                        recipient.maritalStatus = maritalStatus
                        recipient.numberOfChildren = numberOfChildren
                        recipient.paymentPhase = phase
                        recipient.village = village
                        
                        recipient.spendingPlans = spendingPlans
                        recipient.goals = goals
                        recipient.achievements = achievements
                        recipient.challenges = challenges
                        
                        
                        // extract photo URLs from internal array
                        for photoIndex in 0..<path["photos"].count {
                            
                            if path["photos"][photoIndex]["type"] == "family" {
                                recipient.actionURL = path["photos"][photoIndex]["url"].string ?? ""
                            }
                            
                            if path["photos"][photoIndex]["type"] == "face" {
                                recipient.avatarURL = path["photos"][photoIndex]["url"].string ?? ""
                            }
                        }
                        
                        // seems to be better performance when download starts earlier
//                        GDService.downloadImage(recipient.actionURL) { data in
//                            
//                            let image = UIImage(data: data)
//                            recipient.actionImage = image
//                            
//                        }
                        
                        // append model to array
                        self.recipients.append(recipient)
                        
                    }
                }
                
                // seems like this code is not working?
                self.collectionView?.reloadData()
            
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipientBrowserCell", forIndexPath: indexPath) as! BrowserViewCell
        
        //        let recipientDataForCell = dynamicRecipientData[indexPath.item]["recipient"]
        let recipient = self.recipients[indexPath.item]
        
        // download associated image for cell
        GDService.downloadImage(recipient.actionURL) { data in
            
            let image = UIImage(data: data)
            print(recipient.actionURL)
            cell.profileImageView.image = image
            
        }
        
//        cell.profileImageView.image = recipient.actionImage
        
        cell.configureCellWithData(recipient)
        //        cell.profileImageView.imageFromUrl(recipientImageURL)
        //        cell.profileImageView.downloadImage(recipientImageURL)
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecipientProfileSegue" {
            let toView = segue.destinationViewController as! RecipientProfileTableViewController
            let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            //            let recipient = dynamicRecipientData[indexPath!.item]
            let recipient = self.recipients[indexPath!.item]
            toView.recipient = recipient
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
        let annotation = self.recipients[indexPath.item].spendingPlans
        //        let story = annotation.string ?? ""
        let font = UIFont.systemFontOfSize(14)
        let storyHeight = self.heightForStory(annotation, font: font, width: width)
        let height = 4 + 17 + 4 + storyHeight + 4
        return height
    }
}