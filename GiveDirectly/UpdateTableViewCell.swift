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
    func recipientImageDidTap(cell: UpdateTableViewCell, sender: AnyObject)
}

class UpdateTableViewCell: UITableViewCell {
    
    weak var delegate: UpdateTableViewCellDelegate?
    
    var userHasLiked = false
    var numberOfLikes = 0

    @IBOutlet weak var authorImageView: AsyncImageView! {
        didSet {
            print("A newsfeed item's profile image was set.")
        }
    }
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
        
        self.userHasLiked = !userHasLiked
        
        if userHasLiked {
            likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes += 1
        } else {
            likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes -= 1
        }
        
        
//        delegate?.updateLikeButtonDidTap(self, sender: sender)
        self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
        print("Like has been tapped.")
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        commentButton.animation = "pop"
        commentButton.force = 3
        commentButton.animate()
        
        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        extraButton.animation = "pop"
        extraButton.force = 3
        extraButton.animate()
        
        //        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    
    func recipientImageTapped(sender: AnyObject) {

        delegate?.recipientImageDidTap(self, sender: sender)
    }
    
    
    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(update: Update) {
        
//        print(updateData)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("recipientImageTapped:"))
        authorImageView?.userInteractionEnabled = true
        authorImageView?.addGestureRecognizer(tapGestureRecognizer)
        
        let displayName: String? = update.recipientDisplayName ?? ""
        let title: String? = update.updateTitle ?? ""
        let updateText: String? = update.text ?? ""
        
        
        authorImageView.makeRound()

        // format date as human-readable
        let date:String = update.date ?? ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let displayDate = dateFormatter.dateFromString(date)
        
        // can choose between LongStyle, MediumStyle, and ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        // TODO: figure out how to make this line fail gracefully if date is nil
        let dateString = dateFormatter.stringFromDate(displayDate!)

        // assign UI fields
        self.authorImageView.image = update.avatarImage
        self.timestampLabel.text = dateString
        self.authorNameLabel.text = displayName ?? ""
        self.updateTitleLabel.text = title ?? ""
        self.updateStoryLabel.text = updateText ?? ""
        self.updateStoryLabel.sizeToFit()
    }
    
//    func configureLikeForCell(withUpdate: Update) {
    func configureLikeForCell(withNumberOfLikes: Int) {
    
        //        print(withUpdate.userHasLikedUpdate)
        self.userHasLiked = !userHasLiked
        print(self.userHasLiked)
        
        self.likeButton.setTitle(String(withNumberOfLikes), forState: UIControlState.Normal)
//        
//        if withUpdate.userHasLikedUpdate {
//            // change the image
        
//            likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
//
//        } else {
//            // image is hollow with unchanged count
//            likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
//        }
    }
}
