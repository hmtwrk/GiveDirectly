//
//  FirstTransferTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientUpdatesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recipientImageView: UIImageView!
    
    @IBOutlet weak var transferStoryTextView: UITextView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // Should comment be a label or a textview?
    // The comment should be able to expand vertically quite a bit.
    
    
    // setting the borderColor to whiteColor created a barely visible halo around the border
    func configureRecipientUpdates() {
        recipientImageView.layer.cornerRadius = self.recipientImageView.frame.size.width / 2
        recipientImageView.clipsToBounds = true
        recipientImageView.layer.borderWidth = 2.0
        recipientImageView.layer.borderColor = UIColor.clearColor().CGColor
        recipientImageView.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    
}
