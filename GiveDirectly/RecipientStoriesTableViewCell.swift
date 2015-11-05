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
    @IBOutlet weak var paymentPhaseImageView: UIImageView!

    func configureStoriesCell(recipientStories: JSON) {
        
        
        let recipientSpendingPlans:String? = recipientStories["spendingPlans"].string
        let recipientGoals:String? = recipientStories["goals"].string
        let recipientAchievements:String? = recipientStories["achievements"].string
        let recipientChallenges:String? = recipientStories["challenges"].string
        let paymentPhase:Int? = recipientStories["phase"].int
        
        self.spendingPlansTextView.text = recipientSpendingPlans
//        self.paymentTextView.sizeToFit()
        self.goalsTextView.text = recipientGoals
//        self.goalsTextView.sizeToFit()
        self.achievementsTextView.text = recipientAchievements
//        self.challengesTextView.sizeToFit()
        self.hardshipsTextView.text = recipientChallenges
//        self.hardshipsTextView.sizeToFit()

        
        
//        print("===============")
//        print(recipientStories["phase"])
//        print(paymentPhase)
        
        // display proper payment phase
//        switch paymentPhase! {
//        case 1:
//            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
//        case 2:
//            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
//        default:
//            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
//        }
        
        donorImageView.layer.cornerRadius = self.donorImageView.frame.size.width / 2
        donorImageView.clipsToBounds = true
        donorImageView.layer.borderWidth = 2.0
        donorImageView.layer.borderColor = UIColor.clearColor().CGColor
        donorImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
    }

}
