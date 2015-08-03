//
//  UserAccountRecentActivityTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecentActivityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var recentActivityImageView: UIImageView!
    

    func configureLatestActivityCell() {
        recentActivityImageView.layer.cornerRadius = self.recentActivityImageView.frame.size.width / 2
        recentActivityImageView.clipsToBounds = true
        recentActivityImageView.layer.borderWidth = 2.0
        recentActivityImageView.layer.borderColor = UIColor.clearColor().CGColor
        recentActivityImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
    }

}
