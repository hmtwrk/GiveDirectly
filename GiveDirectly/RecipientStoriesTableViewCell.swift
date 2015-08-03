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


    func configureStoriesCell(recipientStories: AnyObject) {
        
        println(recipientStories)
        
        let recipientPayment:String? = (recipientStories as AnyObject)["spending"] as? String
        let recipientGoals:String? = (recipientStories as AnyObject)["goals"] as? String
        let recipientHardships:String? = (recipientStories as AnyObject)["hardship"] as? String
        let recipientChallenges:String? = (recipientStories as AnyObject)["day"] as? String
        
        self.paymentTextView.text = recipientPayment
        self.goalsTextView.text = recipientGoals
        self.hardshipsTextView.text = recipientHardships
        self.challengesTextView.text = recipientChallenges
        
        donorImageView.layer.cornerRadius = self.donorImageView.frame.size.width / 2
        donorImageView.clipsToBounds = true
        donorImageView.layer.borderWidth = 2.0
        donorImageView.layer.borderColor = UIColor.clearColor().CGColor
        donorImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
    }

}
