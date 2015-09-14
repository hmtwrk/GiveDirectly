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

    
    
    func configureUserProfileCell(userData: AnyObject, willShowDonationTracker: Bool) {
        
//        println(userData)

        let userName:String? = (userData as AnyObject)["fullName"] as? String
        let userMessage:String? = (userData as AnyObject)["message"] as? String
        let userJoinDate:String? = (userData as AnyObject)["createdAt"] as? String
        let userDonations:Int? = (userData as AnyObject)["donations"] as? Int
        let userFunded:Int? = (userData as AnyObject)["funded"] as? Int
        let userLocation:String? = (userData as AnyObject)["location"] as? String
        
        // display donationTracker if GD site was visited
        if willShowDonationTracker == true {
            
//            userLocationLabel.backgroundColor = UIColor.blueColor()
            // this logic works... now to add a view here and put it in the right place
            
            // delete
            
//            var dynamicView = UIView(frame: CGRectMake(100, 100, 100, 100))
//            dynamicView.backgroundColor = UIColor.greenColor()
//            dynamicView.layer.cornerRadius = 25
//            dynamicView.layer.borderWidth = 2
//            self.addSubview(dynamicView)
            
            removeableBottomConstraint.constant = 72
            
            

            let imageName = "donationTracker.pdf"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
//            let horizontalCenter = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
            imageView.frame = CGRect(x: ( (self.contentView.bounds.size.width - imageView.frame.size.width) / 2.0), y: (18 + 80 + (75 - 8) ), width: 292, height: 64)
            imageView.contentMode = .Center
            self.addSubview(imageView)
            
            self.layoutIfNeeded()
            
        }

        
        
        // configure round profile image
        userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.layer.borderWidth = 2.0
        userPhotoImageView.layer.borderColor = UIColor.clearColor().CGColor
        userPhotoImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        

        
        // load profile photo
        // TODO: move this code into helper method
        if let userProfilePhoto = userData["profilePhoto"] as? PFFile {
            userProfilePhoto.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    self.userPhotoImageView.image = image
                }
            }
        } else {
            self.userPhotoImageView.image = UIImage(named: "blankProfileImage")
        }
        
        if userDonations != nil {
            
            var formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
//            formatter.usesGroupingSeparator = true
            formatter.usesSignificantDigits = true
            var currencyUserDonations = formatter.stringFromNumber(userDonations!)
            
            
//            self.userDonationsLabel.text = String(stringInterpolationSegment: userDonations!)
            self.userDonationsLabel.text = currencyUserDonations
        }
        
        if userFunded != nil {
            
            self.userFundedLabel.text = String(stringInterpolationSegment: userFunded!)
        }
        
        self.userNameLabel.text = userName
        self.userJoinDateLabel.text = userJoinDate
        self.userLocationLabel.text = userLocation
        self.userMessageLabel.text = userMessage

        
    }
    
    
}
