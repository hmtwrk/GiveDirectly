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

    

    func configureUserProfileCell() {
        
        userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2
        userPhotoImageView.clipsToBounds = true
        userPhotoImageView.layer.borderWidth = 2.0
        userPhotoImageView.layer.borderColor = UIColor.clearColor().CGColor
        userPhotoImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
    }


}
