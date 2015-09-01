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
    @IBOutlet weak var paymentTextView: AutoTextView!
    @IBOutlet weak var goalsTextView: AutoTextView!
    @IBOutlet weak var hardshipsTextView: AutoTextView!
    @IBOutlet weak var challengesTextView: AutoTextView!
    @IBOutlet weak var paymentPhaseImageView: UIImageView!

    func configureStoriesCell(recipientStories: AnyObject) {
        
        let recipientPayment:String? = (recipientStories as AnyObject)["spending"] as? String
        let recipientGoals:String? = (recipientStories as AnyObject)["goals"] as? String
        let recipientHardships:String? = (recipientStories as AnyObject)["achievement"] as? String
        let recipientChallenges:String? = (recipientStories as AnyObject)["challenges"] as? String
        let paymentPhase:Int? = (recipientStories as AnyObject)["phase"] as? Int
        
        self.paymentTextView.text = recipientPayment
        self.paymentTextView.sizeToFit()
        self.goalsTextView.text = recipientGoals
        self.goalsTextView.sizeToFit()
        self.hardshipsTextView.text = recipientHardships
        self.hardshipsTextView.sizeToFit()
        self.challengesTextView.text = recipientChallenges
        self.challengesTextView.sizeToFit()
        
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
