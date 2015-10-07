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
        let paymentPhase:Int? = (recipientInfo as AnyObject)["phase"] as? Int

        switch paymentPhase! {
        case 1:
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case 2:
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        // assign constants to labels
        self.nameLabel.text = recipientName
        self.storyLabel.text = recipientProfileStory
        
//      self.timeLabel.text = "0d"
//      self.profileImageView.image = image
    }
    
    
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attributes = layoutAttributes as! BrowserLayoutAttributes
        profileImageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
