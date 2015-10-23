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
    
    var displayName: String = ""

    
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
    
    // TODO: this function would have a parameter type of JSON:
     func configureCellWithData(data: JSON) {
//    func configureCellWithParse(recipientInfo: AnyObject) {
    
        // Ming To style:
        // let displayName = data["firstName"].string!
        // (using implicitly unwrapped optional will crash if data is nil, however) solve this way:
        // let displayName = data["firstName"].string ?? ""
        
//        print(data)
        
        let recipientName = data["firstName"].string ?? "Kangaroo"
        let recipientStory = data["goals"].string ?? "jumpin' around"
        let paymentPhase = data["phase"].int ?? 0
//        let recipientName:String? = recipientInfo["firstName"] as? String
//        let recipientProfileStory:String? = (recipientInfo as AnyObject)["goals"] as? String
//        let paymentPhase:Int? = (recipientInfo as AnyObject)["phase"] as? Int
        
        

        switch paymentPhase {
        case 1:
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case 2:
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        // assign constants to labels
        self.nameLabel.text = recipientName
//        self.storyLabel.text = recipientProfileStory
        self.storyLabel.text = recipientStory
        
    }
    
    
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attributes = layoutAttributes as! BrowserLayoutAttributes
        profileImageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
