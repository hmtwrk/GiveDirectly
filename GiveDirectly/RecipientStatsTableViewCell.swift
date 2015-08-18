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
    @IBOutlet weak var recipientJobTitleLabel: UILabel!
    @IBOutlet weak var recipientNumberOfChildrenLabel: UILabel!
//    @IBOutlet weak var recipientLocationLabel: UILabel!
    
    
    
    func configureStatsCell(recipientStats: AnyObject) {
        
        let recipientName:String? = (recipientStats as AnyObject)["firstName"] as? String
        let recipientAge:Int? = (recipientStats as AnyObject)["age"] as? Int
        let recipientJob:String? = (recipientStats as AnyObject)["income"] as? String
//        let recipientLocation:String? = (recipientStats as AnyObject)["location"] as? String
        
        var recipientNumberOfChildren:Int? = (recipientStats as AnyObject)["children"] as? Int
//        let recipientProfilePhoto = recipientStats["profileSquarePhoto"] as! PFFile
        

//        recipientProfilePhoto.getDataInBackgroundWithBlock({
//            (imageData: NSData?, error: NSError?) -> Void in
//            if (error == nil) {
//                let image = UIImage(data: imageData!)
//                self.recipientProfileImageView.image = image
//            }
//        })
        
        
        // safely convert Int to String without "Optional" appearing
        if recipientAge != nil {
            self.recipientAgeLabel.text = String(stringInterpolationSegment: recipientAge!)
        }
        
        if recipientNumberOfChildren != nil {
            self.recipientNumberOfChildrenLabel.text = String(stringInterpolationSegment: recipientNumberOfChildren!)
        }
        
        // assign variables and constants to labels
        self.recipientNameLabel.text = recipientName
        self.recipientJobTitleLabel.text = recipientJob?.capitalizedString
//        self.recipientLocationLabel.text = recipientLocation
        
        // make profile image round
        recipientProfileImageView.layer.cornerRadius = self.recipientProfileImageView.frame.size.width / 2
        recipientProfileImageView.clipsToBounds = true
        recipientProfileImageView.layer.borderWidth = 2.0
        recipientProfileImageView.layer.borderColor = UIColor.clearColor().CGColor
        recipientProfileImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        
    }
    
    
    
    
}
