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
    
    
    
    func configureUserProfileCell(userData: AnyObject) {
        
        println(userData)
        
        let userName:String? = (userData as AnyObject)["fullName"] as? String
        let userMessage:String? = (userData as AnyObject)["message"] as? String
        let userJoinDate:String? = (userData as AnyObject)["createdAt"] as? String
        let userDonations:String? = (userData as AnyObject)["donations"] as? String
        let userFunded:String? = (userData as AnyObject)["funded"] as? String
        let userLocation:String? = (userData as AnyObject)["location"] as? String
        let userProfilePhoto = userData["profilePhoto"] as! PFFile
        
        // configure round profile image
        userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.layer.borderWidth = 2.0
        userPhotoImageView.layer.borderColor = UIColor.clearColor().CGColor
        userPhotoImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        // load profile photo (make into helper method)
        userProfilePhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.userPhotoImageView.image = image
            }
        })
        
        if userMessage != nil {
            self.userMessageLabel.text = userMessage
        }
        
        self.userNameLabel.text = userName
        self.userJoinDateLabel.text = userJoinDate
        self.userDonationsLabel.text = userDonations
        self.userFundedLabel.text = userFunded
        self.userLocationLabel.text = userLocation
        
    }
    
    
}
