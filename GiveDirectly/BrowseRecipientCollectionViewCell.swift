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
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var storyTextView: AutoTextView!
    

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coloredBarView: UIView!
    
    // TODO: @IBAction for clicking on the button to see close-up of profile
    // TODO: @IBAction for clicking on the heart(?)


    
    func configureCellWithParse(recipientInfo: AnyObject) {
        

        // assign variables / constants from the Parse query to outlets
        let recipientName:String? = (recipientInfo as AnyObject)["recipientName"] as? String
        let recipientAge:Int? = (recipientInfo as AnyObject)["age"] as? Int
        let recipientJob:String? = (recipientInfo as AnyObject)["job"] as? String
//        let recipientLocation:String? = (recipientInfo as AnyObject)["location"] as? String
        var recipientNumberOfChildren:Int? = (recipientInfo as AnyObject)["numberOfChildren"] as? Int
        let recipientProfileStory:String? = (recipientInfo as AnyObject)["profileStory"] as? String
        let recipientProfilePhoto = recipientInfo["profilePhoto"] as! PFFile
        
        // TODO: make the optional safe for an image not existing in Parse
        recipientProfilePhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.profileImageView.image = image
            }
        })
        
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
