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
    @IBOutlet weak var profileImageView: UIImageViewAsync!
    @IBOutlet weak var profileImageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentPhaseImageView: UIImageView! {
        
        didSet {
            // just testing the observable functionality
            print("A dynamic view cell image has been set!")
        }
        
    }

    
    var displayName: String = ""
    
    func configureCellWithData(recipient: Recipient) {
        
        // assign values or use default
        let recipientName = recipient.firstName
        let recipientStory = recipient.spendingPlans
        let paymentPhase = recipient.paymentPhase
        
        // select proper phase to display
        switch paymentPhase {
        case "1":
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case "2":
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        // assign constants to labels
        self.nameLabel.text = recipientName.capitalizedString
        self.storyLabel.text = recipientStory
        self.profileImageView.image = recipient.actionImage
        
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attributes = layoutAttributes as! BrowserLayoutAttributes
        profileImageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
