//
//  ProfileSummaryTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts
import QuartzCore


class ProfileSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    


    // followButton change to "Following" if already following?
    
    func configureProfileSummary() {
        
        // make profile image round
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        // make follow button round
        followButton.layer.cornerRadius = 5.0
    }


//    func configureWithParse(profile: AnyObject) {
//        
//    }
    
    
}
