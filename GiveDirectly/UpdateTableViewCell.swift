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
    
    // property list
    var update: Update? {
        didSet {
            
            updateDisposable?.dispose()
            
            //            if let update = update {
            
            //                updateDisposable = update.avatarImage.bindTo(authorImageView.bnd_image)
            
            // free memory of image stored with post that is no longer displayed
            // 1 (!= doesn't work, but "non-identical" !== seems to)
            // !== seems to check if the references are different (the same reference, object instance)
            
            // the following code works appropriately, but the behavior is being disrupted by the API call and the initial configuration of the cells
            if let oldValue = oldValue where oldValue !== update {
                print("🍕🍕🍕🍕🍕🍕🍕🍕🍕🍕🍕🍕🍕")
                print("The old value was: \(oldValue.text),")
//                print("🍮🍮🍮🍮🍮🍮🍮🍮🍮🍮🍮🍮🍮")
//                print("...and the new one is: \(update?.text).")
//                oldValue.avatarImage.value = nil
//                print("A secret white mailbox has been discovered and publicized.")
            }
            
            if let update = update {
                updateDisposable = update.avatarImage.bindTo(authorImageView.bnd_image)
            }
            
        }
    }
    
    var updateDisposable: DisposableType?
    
    var userHasLiked = false
    var numberOfLikes = 0
    
    @IBOutlet weak var authorImageView: AsyncImageView!
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
    // instead of calling a function, should TVC just set the property and allow cell to set itself?
    func configureUpdateTableViewCell(update: Update) {
        
        //        print(updateData)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("recipientImageTapped:"))
        authorImageView?.userInteractionEnabled = true
        authorImageView?.addGestureRecognizer(tapGestureRecognizer)
        
        let displayName: String? = update.recipientFirstName ?? ""
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
        //        self.authorImageView.image.value = update.avatarImage
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
