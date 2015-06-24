//
//  BrowseRecipientCollectionViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/22/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts

class BrowseRecipientCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    // wonder if this label should be # of followers?
    @IBOutlet weak var numberOfChildrenLabel: UILabel!

    
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coloredBarView: UIView!
    
    // TODO: @IBAction for clicking on the button to see close-up of profile
    // TODO: @IBAction for clicking on the heart(?)
    // TODO: Do the Parse query on the TestData class
    

    
    
    // ideally would only want to do one Parse query, and not ten queries... one to grab the array
    // for testing, could just plug in an objectId as a String into the parameter of doParseQuery()
    func configureWithBrowseData(objectID:String) {
        var browseQuery:PFQuery = PFQuery(className: "TestData")
        browseQuery.whereKey("objectId", equalTo: objectID)
        browseQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
            
            
            for recipientData in objects! {
                
                // convert Parse profile image file data for use in cell
                let recipientProfilePhoto = recipientData["profilePhoto"] as! PFFile
                recipientProfilePhoto.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data: imageData!)
                        self.profileImageView.image = image
                    }
                })
                
                // assign variables / constants from the Parse query for assignment to labels, etc.
                let recipientName:String? = (recipientData as! PFObject)["recipientName"] as? String
                let recipientAge:Int? = (recipientData as! PFObject)["age"] as? Int
                let recipientJob:String? = (recipientData as! PFObject)["job"] as? String
                let recipientLocation:String? = (recipientData as! PFObject)["location"] as? String
                var recipientNumberOfChildren:Int? = (recipientData as! PFObject)["numberOfChildren"] as? Int
                let recipientProfileStory:String? = (recipientData as! PFObject)["profileStory"] as? String
                
                // safely convert Int to String without "Optional" appearing
                if recipientAge != nil {
                    self.ageLabel.text = String(stringInterpolationSegment: recipientAge!)
                }
                
                if recipientNumberOfChildren != nil {
                    self.numberOfChildrenLabel.text = String(stringInterpolationSegment: recipientNumberOfChildren!)
                }
                
                // assign constants to labels
                self.nameLabel.text = recipientName
                self.jobLabel.text = recipientJob?.capitalizedString
                self.storyTextView.text = recipientProfileStory
                
            }
        }
    }

    
}
