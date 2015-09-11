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
    
    override func awakeFromNib() {
        // 
    }
    
    
    func configureUserProfileCell(userData: AnyObject) {
        
//        println(userData)
        
        // ideally the user would have to pull to refresh the data,
        // but for now the data will update when viewDidAppear
        
        let userName:String? = (userData as AnyObject)["fullName"] as? String
        let userMessage:String? = (userData as AnyObject)["message"] as? String
        let userJoinDate:String? = (userData as AnyObject)["createdAt"] as? String
        let userDonations:Int? = (userData as AnyObject)["donations"] as? Int
        let userFunded:String? = (userData as AnyObject)["funded"] as? String
        let userLocation:String? = (userData as AnyObject)["location"] as? String
        
        
        // configure round profile image
        userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.layer.borderWidth = 2.0
        userPhotoImageView.layer.borderColor = UIColor.clearColor().CGColor
        userPhotoImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        
        // load profile photo (load into helper method)
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
            self.userDonationsLabel.text = String(stringInterpolationSegment: userDonations!)
        }
        
        if userMessage != nil {
            self.userMessageLabel.text = userMessage
        }
        
        self.userNameLabel.text = userName
        self.userJoinDateLabel.text = userJoinDate
//        self.userDonationsLabel.text = userDonations
        self.userFundedLabel.text = userFunded
        self.userLocationLabel.text = userLocation
        
    }
    
    
}
