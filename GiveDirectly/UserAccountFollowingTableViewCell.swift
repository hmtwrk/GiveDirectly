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
        
        userFollowingImageView.makeRound()
        
    }
    
}
