//
//  RecipientRelatedUpdateCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/31/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class RecipientRelatedUpdateCell: UITableViewCell {
    
    var userHasLikedPost = false
    var numberOfLikes: Int = 0
    
    let buttonForce: CGFloat = 1.0
    
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var updateTitleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var updateStoryLabel: UILabel!
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var extraButton: SpringButton!
    
    // TODO: assign Parse data to numberOfLikesLabel and numberOfCommentsLabel
    // TODO: configure labels for number of likes and comments


    // MARK: SpringButton functionality
    @IBAction func likeButtonDidTap(sender: AnyObject) {
        
        likeButton.animation = "pop"
        likeButton.force = buttonForce
        likeButton.animate()
        

        // TODO: create unique image for "already liked" icon, and tweak animation timing
        if userHasLikedPost == false {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes += 1
            self.likeButton.setTitle(toString(numberOfLikes), forState: UIControlState.Normal)
            
        } else {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes -= 1
            self.likeButton.setTitle(toString(numberOfLikes), forState: UIControlState.Normal)
        }
        
        userHasLikedPost = !userHasLikedPost
        println(userHasLikedPost)
        
        
//        delegate?.updateLikeButtonDidTap(self, sender: sender)
        
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        commentButton.animation = "pop"
        commentButton.force = buttonForce
        commentButton.animate()
        
//        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        extraButton.animation = "pop"
        extraButton.force = buttonForce
        extraButton.animate()
        
//        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(recipientName: String, updateData: AnyObject) {
        
        println(updateData)
        
        let title:String? = (updateData as AnyObject)["method"] as? String
        let updateText:String? = (updateData as AnyObject)["life_difference"] as? String
        
        // configure outlets with Parse data
        let author:String! = (updateData as AnyObject)["GDID"] as! String
        // check Recipients class to mine information
        var query = PFQuery(className:"Recipients")
        query.whereKey("gdid", equalTo: author)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // check to see if something exists
                if let objects = objects as? [PFObject] {
                    for object in objects {

                        // if image is pulled
                        if let recipientProfilePhoto = object["image"] as? PFFile {
                            recipientProfilePhoto.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    let image = UIImage(data: imageData!)
                                    self.authorImageView.image = image
                                    self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
                                    self.authorImageView.clipsToBounds = true
                                }
                            }
                        }
                    }
                }
            } else {
                // log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }

        
        // get the date and format
        let date:String = (updateData as AnyObject)["date"] as! String
        var newDate = date.substringToIndex(advance(date.endIndex, -18))
        
        // assign labels and views
        self.authorNameLabel.text = recipientName
        self.updateTitleLabel.text = title!
        self.updateStoryLabel.text = updateText
        self.updateStoryLabel.sizeToFit()
        self.timestampLabel.text = newDate
        
        //        self.likeButton.titleLabel!.text = String(numberOfLikes)
        self.likeButton.setTitle(toString(numberOfLikes), forState: UIControlState.Normal)
        
        
        
    }



}