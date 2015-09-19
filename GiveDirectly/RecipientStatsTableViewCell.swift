//
//  RecipientStatsTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipientProfileImageView: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientNumberOfChildrenLabel: UILabel!
    @IBOutlet weak var recipientStatusLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    
    
    func configureStatsCell(recipientStats: AnyObject) {
        
        let recipientName:String? = (recipientStats as AnyObject)["firstName"] as? String
        let recipientAge:Int? = (recipientStats as AnyObject)["age"] as? Int
        let recipientStatus:String? = (recipientStats as AnyObject)["maritalStatus"] as? String
        let recipientLocation:String? = (recipientStats as AnyObject)["village"] as? String
        let recipientGender:String? = (recipientStats as AnyObject)["gender"] as? String
        let recipientNumberOfChildren:Int? = (recipientStats as AnyObject)["children"] as? Int
        
        
        // load an image
        if let recipientProfilePhoto = recipientStats["image"] as? PFFile {
            recipientProfilePhoto.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    self.recipientProfileImageView.image = image
                }
            }
        } else {
            self.recipientProfileImageView.image = UIImage(named: "blankProfileImage")
        }
        
        
        // safely convert Int to String without "Optional" appearing
        if recipientAge != nil {
            self.recipientAgeLabel.text = String(stringInterpolationSegment: recipientAge!)
        }
        
        if recipientNumberOfChildren != nil {
            self.recipientNumberOfChildrenLabel.text = String(stringInterpolationSegment: recipientNumberOfChildren!)
        }
        
        // assign variables and constants to labels
        self.recipientNameLabel.text = recipientName
        
        // determine martial status
        var maritalStatus:String!
        switch recipientStatus! {
        case "single":
            maritalStatus = "Single"
        case "couple":
            maritalStatus = "Married"
        case "widow_widower":
            if recipientGender == "female" {
                maritalStatus = "Widow"
            } else {
                maritalStatus = "Widower"
            }
        case "seperated":
            maritalStatus = "Seperated"
        default:
            maritalStatus = "N/A"
        }
        self.recipientStatusLabel.text = maritalStatus
        self.recipientLocationLabel.text = recipientLocation?.capitalizedString
        
        // make profile image round
        recipientProfileImageView.layer.cornerRadius = self.recipientProfileImageView.frame.size.width / 2
        recipientProfileImageView.clipsToBounds = true
        recipientProfileImageView.layer.borderWidth = 2.0
        recipientProfileImageView.layer.borderColor = UIColor.clearColor().CGColor
        recipientProfileImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        
    }
    
    
    
    
}
