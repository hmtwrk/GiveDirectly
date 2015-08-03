//
//  UserAccountFollowingTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/28/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UserAccountFollowingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userFollowingImageView: UIImageView!
    
    
    func configureYourNetworkCell() {
        
        userFollowingImageView.layer.cornerRadius = self.userFollowingImageView.frame.size.width / 2
        userFollowingImageView.clipsToBounds = true
        userFollowingImageView.layer.borderWidth = 2.0
        userFollowingImageView.layer.borderColor = UIColor.clearColor().CGColor
        userFollowingImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
    }
    
}
