//
//  ProfileSummaryTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import QuartzCore


class ProfileSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    


    // TODO: change followButton label to "Following" if already following
    
    func configureProfileSummary(recipientInfo: AnyObject) {
        
        // import the data from the original Parse query on the Collection View controller
        let recipientName:String? = (recipientInfo as AnyObject)["name"] as? String
        let recipientAge:Int? = (recipientInfo as AnyObject)["age"] as? Int
        let recipientJob:String? = (recipientInfo as AnyObject)["job"] as? String
        let recipientLocation:String? = (recipientInfo as AnyObject)["location"] as? String
        var recipientNumberOfChildren:Int? = (recipientInfo as AnyObject)["numberOfChildren"] as? Int
        let recipientProfileStory:String? = (recipientInfo as AnyObject)["profileStory"] as? String
        let recipientProfilePhoto = recipientInfo["profileSquarePhoto"] as! PFFile
        
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
        
        // assign variables and constants to labels
        self.nameLabel.text = recipientName
        self.jobLabel.text = recipientJob?.capitalizedString
        self.storyTextView.text = recipientProfileStory
        self.locationLabel.text = recipientLocation
        
        
        // make profile image round
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.clearColor().CGColor
        profileImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        // make follow button round
        followButton.layer.cornerRadius = 5.0
    }
}
