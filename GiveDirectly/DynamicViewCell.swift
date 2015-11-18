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
    @IBOutlet weak var paymentPhaseImageView: UIImageView!
    //  @IBOutlet weak var timeLabel: UILabel!
    
    var displayName: String = ""
    
    func configureCellWithData(data: JSON, andRecipientImageURL recipientImageURL: String) {
        
        // assign values or use default
        let recipientName = data["firstName"].string ?? ""
        let recipientStory = data["spendingPlans"].string ?? ""
        let paymentPhase = data["phase"].int ?? 0
        
        // select proper phase to display
        switch paymentPhase {
        case 1:
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case 2:
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        // assign constants to labels
        self.nameLabel.text = recipientName.capitalizedString
        self.storyLabel.text = recipientStory
        
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attributes = layoutAttributes as! BrowserLayoutAttributes
        profileImageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
