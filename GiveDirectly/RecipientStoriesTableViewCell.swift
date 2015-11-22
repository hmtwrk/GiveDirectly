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

    func configureStoriesCell(recipient: Recipient) {
        
        self.spendingPlansTextView.text = recipient.spendingPlans
//        self.paymentTextView.sizeToFit()
        self.goalsTextView.text = recipient.goals
//        self.goalsTextView.sizeToFit()
        self.achievementsTextView.text = recipient.achievements
//        self.challengesTextView.sizeToFit()
        self.hardshipsTextView.text = recipient.challenges
//        self.hardshipsTextView.sizeToFit()

        
        // display proper payment phase
        switch recipient.paymentPhase {
        case "1":
            self.paymentPhaseImageView.image = UIImage(named: "phasePayment")
        case "2":
            self.paymentPhaseImageView.image = UIImage(named: "phaseComplete")
        default:
            self.paymentPhaseImageView.image = UIImage(named: "phaseRegistration")
        }
        
        donorImageView.makeRound()
    }

}
