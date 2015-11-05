//
//  UserAccountProfileTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/28/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UserAccountProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var userJoinDateLabel: UILabel!
    @IBOutlet weak var userDonationsLabel: UILabel!
    @IBOutlet weak var userFundedLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var removeableBottomConstraint: NSLayoutConstraint!

    var donationTrackerHasAppeared = false
    
    
    func configureUserProfileCell(userData: JSON, willShowDonationTracker: Bool) {

        let firstName:String? = userData["firstName"].string ?? ""
        let lastName:String? = userData["lastName"].string ?? ""
        let profileMessage:String? = userData["profileMessage"].string ?? ""
        let joinedDate:String? = userData["joinedDate"].string ?? ""
        let donationsYTD:Int? = userData["donationsYTD"].int ?? 0
        let userFunded:Int? = userData["funded"].int ?? 0 // TODO: add field for total funded
        let location:String? = userData["location"].string ?? "N/A"
 
        // configure round profile image
        userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.layer.borderWidth = 2.0
        userPhotoImageView.layer.borderColor = UIColor.clearColor().CGColor
        userPhotoImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let displayDate = dateFormatter.dateFromString(joinedDate!)
        
        
        if donationsYTD != nil {
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
//            formatter.usesGroupingSeparator = true
            formatter.usesSignificantDigits = true
            let currencyUserDonations = formatter.stringFromNumber(donationsYTD!)

//            self.userDonationsLabel.text = String(stringInterpolationSegment: userDonations!)
            self.userDonationsLabel.text = currencyUserDonations
        }
        
        if userFunded != nil {
            
            self.userFundedLabel.text = String(stringInterpolationSegment: userFunded!)
        }
        
        self.userNameLabel.text = firstName! + " " + lastName!
        self.userJoinDateLabel.text = displayDate?.ago
        self.userLocationLabel.text = location
        self.userMessageLabel.text = profileMessage

        
    }
    
    
}
