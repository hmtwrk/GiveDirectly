//
//  FirstTransferTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientUpdatesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submittedPhotoImageView: UIImageView!
    @IBOutlet weak var recipientImageView: UIImageView!
    
    @IBOutlet weak var updateTitleLabel: UILabel!
    @IBOutlet weak var transferStoryTextView: UITextView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func configureRecipientUpdates(recipientInfo: AnyObject) {
        
        // import the data from the original Parse query on the Collection View controller
        let recipientName:String? = (recipientInfo as AnyObject)["recipientName"] as? String
        let recipientGender:String? = (recipientInfo as AnyObject)["gender"] as? String
        let recipientProfilePhoto = recipientInfo["profileSquarePhoto"] as! PFFile
        let submittedPhoto = recipientInfo["profilePhoto"] as! PFFile
        

        
        recipientProfilePhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.recipientImageView.image = image
            }
        })
        
        submittedPhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.submittedPhotoImageView.image = image
            }
        })
        
        // assign variables and constants to labels
        self.recipientNameLabel.text = recipientName
        
        if recipientGender == "f" {
            self.updateTitleLabel.text = "on her transfer:"
        } else {
            self.updateTitleLabel.text = "on his transfer:"
        }
        
        // make profile image 
        // setting the borderColor to whiteColor created a barely visible halo around the border
        recipientImageView.layer.cornerRadius = self.recipientImageView.frame.size.width / 2
        recipientImageView.clipsToBounds = true
        recipientImageView.layer.borderWidth = 2.0
        recipientImageView.layer.borderColor = UIColor.clearColor().CGColor
        recipientImageView.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    
    
    
}
