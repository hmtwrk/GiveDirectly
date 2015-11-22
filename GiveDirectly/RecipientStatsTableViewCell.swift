//
//  RecipientStatsTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientStatsTableViewCell: UITableViewCell {
    
    var recipient = Recipient()
    
    @IBOutlet weak var recipientProfileImageView: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientNumberOfChildrenLabel: UILabel!
    @IBOutlet weak var recipientStatusLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    
    
    func configureStatsCell(recipient: Recipient) {
        
        // assign data to labels
        self.recipientNameLabel.text = self.recipient.displayName
        self.recipientAgeLabel.text = String(self.recipient.age)
        self.recipientNumberOfChildrenLabel.text = String(self.recipient.numberOfChildren)
        
        // determine martial status
        var maritalStatus:String!
        switch self.recipient.maritalStatus {
        case "single":
            maritalStatus = "Single"
        case "couple":
            maritalStatus = "Married"
        case "widow_widower":
            if self.recipient.gender == "f" {
                maritalStatus = "Widow"
            } else {
                maritalStatus = "Widower"
            }
        case "seperated":
            maritalStatus = "Seperated"
        default:
            maritalStatus = "N/A"
        }
        
        self.recipientStatusLabel.text = maritalStatus
        self.recipientLocationLabel.text = self.recipient.village.capitalizedString
        
        // make profile image round
        recipientProfileImageView.makeRound()
    }
}
