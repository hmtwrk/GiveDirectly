//
//  DynamicViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class BrowserViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentPhaseImageView: UIImageView!
//  @IBOutlet weak var timeLabel: UILabel!
    
//    var recipient: Recipient? {
//        didSet {
//            if let recipient = recipient {
//                nameLabel.text = recipient.recipientName
//                storyLabel.text = recipient.recipientStory
//                profileImageView.image = recipient.recipientImage
//                paymentPhaseImageView.image = recipient.paymentPhaseImage
//                timeLabel.text = recipient.timeStamp
//            }
//        }
//    }
    
    var recipient: Recipient? {
        didSet {
            if let recipient = recipient {
                profileImageView.image = recipient.image
                nameLabel.text = recipient.caption
                storyLabel.text = recipient.comment
//              timeLabel.text = "0d"
            }
        }
    }
    
    func configureCellWithParse(recipientInfo: AnyObject) {
        
        let recipientName:String? = (recipientInfo as AnyObject)["firstName"] as? String
        let recipientProfileStory:String? = (recipientInfo as AnyObject)["goals"] as? String
        
        // load an image
        if let recipientProfilePhoto = recipientInfo["image"] as? PFFile {
            recipientProfilePhoto.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    self.profileImageView.image = image
                }
            }
        } else {
            self.profileImageView.image = UIImage(named: "blankProfileImage")
        }
        
        // make image round
        /**
        paymentPhaseImageView.layer.cornerRadius = self.paymentPhaseImageView.frame.size.width / 2
        paymentPhaseImageView.clipsToBounds = true
        paymentPhaseImageView.layer.borderWidth = 2.0
        paymentPhaseImageView.layer.borderColor = UIColor.clearColor().CGColor
        **/
        
        // assign constants to labels
        self.nameLabel.text = recipientName
        self.storyLabel.text = recipientProfileStory
        
//      self.timeLabel.text = "0d"
//      self.profileImageView.image = image
    }
    
    
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attributes = layoutAttributes as! BrowserLayoutAttributes
        profileImageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
