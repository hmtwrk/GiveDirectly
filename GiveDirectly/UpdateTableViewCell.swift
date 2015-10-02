//
//  UpdateTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

protocol UpdateTableViewCellDelegate: class {
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject)
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject)
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject)
}

class UpdateTableViewCell: UITableViewCell {
    
    weak var delegate: UpdateTableViewCellDelegate?
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var updateTitleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var updateStoryLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var extraButton: UIButton!

    // MARK: SpringButton functionality
    @IBAction func likeButtonDidTap(sender: AnyObject) {
    
        delegate?.updateLikeButtonDidTap(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    

    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(updateData: AnyObject) {
        
        // TODO: modify the following cast to not crash if the recipientAuthor field is nil
        let recipientData:PFObject = (updateData["recipientAuthor"] as? PFObject)!
        let title:String? = (updateData as AnyObject)["method"] as? String
        let updateText:String? = (updateData as AnyObject)["life_difference"] as? String
        
        // get the date and format (does this need to be set to optional? App will crash if
        // the "date" field on RecipientUpdates is nil)
        let date:String = (updateData as AnyObject)["date"] as! String
        let newDate = date.substringToIndex(date.endIndex.advancedBy(-18))
        let recipientName = recipientData["firstName"] as! String

        // assign labels and views (also needs to be set to optional)
        self.authorNameLabel.text = recipientName
        self.updateTitleLabel.text = title!
        self.updateStoryLabel.text = updateText
        self.updateStoryLabel.sizeToFit()
        self.timestampLabel.text = newDate
        
    }
    
    func configureLikeForCell(withUpdate: Update) {
        
        self.likeButton.setTitle(String(withUpdate.numberOfLikes), forState: UIControlState.Normal)
        
        if withUpdate.userHasLikedUpdate {
            // change the image
            likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            
        } else {
            // image is hollow with unchanged count
            likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
        }
    }
}
