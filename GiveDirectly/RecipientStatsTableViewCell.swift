//
//  RecipientStatsTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/2/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipientProfileImageView: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientNumberOfChildrenLabel: UILabel!
    @IBOutlet weak var recipientStatusLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    
    
    func configureStatsCell(recipientStats: JSON) {
        
        let recipientName:String? = recipientStats["firstName"].string
        let recipientAge:Int? = recipientStats["age"].int
        let recipientStatus:String? = recipientStats["maritalStatus"].string
        let recipientLocation:String? = recipientStats["village"].string
        let recipientGender:String? = recipientStats["gender"].string
        let recipientNumberOfChildren:Int? = recipientStats["children"].int

        // safely convert Int to String without "Optional" appearing
        if recipientAge != nil {
            self.recipientAgeLabel.text = String(stringInterpolationSegment: recipientAge!)
        }
        
        if recipientNumberOfChildren != nil {
            self.recipientNumberOfChildrenLabel.text = String(stringInterpolationSegment: recipientNumberOfChildren!)
        }
        
        // assign variables and constants to labels
        self.recipientNameLabel.text = recipientName?.capitalizedString
        
        // determine martial status
        var maritalStatus:String!
        switch recipientStatus! {
        case "single":
            maritalStatus = "Single"
        case "couple":
            maritalStatus = "Married"
        case "widow_widower":
            if recipientGender == "female" {
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
        self.recipientLocationLabel.text = recipientLocation?.capitalizedString
        
        // make profile image round
        recipientProfileImageView.makeRound()
    }
}
