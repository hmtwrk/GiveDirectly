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
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var extraButton: SpringButton!
    
    // MARK: SpringButton functionality
    @IBAction func likeButtonDidTap(sender: AnyObject) {
        
        likeButton.animation = "pop"
        likeButton.force = 3
        likeButton.animate()
        
        //        delegate?.updateLikeButtonDidTap(self, sender: sender)
        print("Like has been tapped.")
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        commentButton.animation = "pop"
        commentButton.force = 3
        commentButton.animate()
        
        //        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        extraButton.animation = "pop"
        extraButton.force = 3
        extraButton.animate()
        
        //        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    
    
    
    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(updateData: JSON) {
        
        //        print(updateData)
        
        let displayName: String? = updateData["displayName"].string
        // title should be a curated and unique field for each update
        let title: String? = updateData["title"].string
        let updateText: String? = updateData["update"].string
        //        let authorPortraitURL = updateData["recipientAvatar"].string
        
        //        if let imageURL: NSURL = NSURL(string: authorPortraitURL!)! {
        //            imageRequest(imageURL)
        //            print(imageURL)
        //        }
        
        //        print(recipientPortraitURL!)
        
        authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
        authorImageView.clipsToBounds = true
        authorImageView.layer.borderWidth = 2.0
        authorImageView.layer.borderColor = UIColor.clearColor().CGColor
        authorImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        
        // get the date and format (does this need to be set to optional? App will crash if
        // the "date" field on RecipientUpdates is nil)
        let JSONdate:String = updateData["surveyDate"].string ?? ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let displayDate: NSDate? = dateFormatter.dateFromString(JSONdate)

        
//        self.timestampLabel.text = dateFormatter.stringFromDate(displayDate!
        
//        self.timestampLabel.text = displayDate!.ago
        self.timestampLabel.text = JSONdate

        
        //        print(displayDate!.ago)
        
        //        self.authorImageView.url = authorPortraitURL?.toURL()
        //        self.authorImageView.placeholderImage = UIImage(named: "blankProfileImage")
        //        self.timestampLabel.text = displayDate!.ago
        
        
        //        self.timestampLabel.text = date.substringToIndex(date.endIndex.advancedBy(-18))
        
        // assign labels and views (also needs to be set to optional)
        //        self.authorNameLabel.text = recipientName
        self.authorNameLabel.text = displayName ?? ""
        self.updateTitleLabel.text = title ?? ""
        self.updateStoryLabel.text = updateText ?? ""
        self.updateStoryLabel.sizeToFit()
    }
    
    func configureLikeForCell(withUpdate: Update) {
        
        //        print(withUpdate.userHasLikedUpdate)
        
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
