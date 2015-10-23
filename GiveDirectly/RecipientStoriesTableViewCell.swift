//
//  RecipientStoriesTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientStoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var donorImageView: UIImageView!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var spendingPlansTextView: UITextView!
    @IBOutlet weak var achievementsTextView: UITextView!
    @IBOutlet weak var goalsTextView: UITextView!
    @IBOutlet weak var hardshipsTextView: UITextView!
    
    
    // TODO: need to configure the story section labels "HARDSHIPS", "SPENDING PLANS" etc.
    // to be hidden if there is no associated data
    
    @IBOutlet weak var paymentPhaseImageView: UIImageView!

    func configureStoriesCell(recipientStories: JSON) {
        
        let recipientPayment:String? = recipientStories["recipients"]["spending"].string
        let recipientGoals:String? = recipientStories["recipients"]["goals"].string
        let recipientHardships:String? = recipientStories["recipients"]["achievement"].string
        let recipientChallenges:String? = recipientStories["recipients"]["challenges"].string
        let paymentPhase:Int? = recipientStories["recipients"]["phase"].int
        
        self.spendingPlansTextView.text = recipientPayment
//        self.paymentTextView.sizeToFit()
        self.goalsTextView.text = recipientGoals
//        self.goalsTextView.sizeToFit()
        self.hardshipsTextView.text = recipientHardships
//        self.hardshipsTextView.sizeToFit()
        self.achievementsTextView.text = recipientChallenges
//        self.challengesTextView.sizeToFit()
        
        // display proper payment phase
        switch paymentPhase! {
        case 1:
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case 2:
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        donorImageView.layer.cornerRadius = self.donorImageView.frame.size.width / 2
        donorImageView.clipsToBounds = true
        donorImageView.layer.borderWidth = 2.0
        donorImageView.layer.borderColor = UIColor.clearColor().CGColor
        donorImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
    }

}
