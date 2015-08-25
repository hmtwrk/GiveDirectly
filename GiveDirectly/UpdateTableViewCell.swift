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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // code to run when cell appears (from being queued, etc.)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        

    }
    
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

        
        delegate?.updateLikeButtonDidTap(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        commentButton.animation = "pop"
        commentButton.force = buttonForce
        commentButton.animate()
        
        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        extraButton.animation = "pop"
        extraButton.force = buttonForce
        extraButton.animate()
        
        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    

    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(updateData: AnyObject) {
        
        // have to get the updateData[indexPath.row] in table view controller for subscripting to work like below...
        
        // TODO: query Parse to determine if user has already liked the update
        // need to cast as PFObject to get at the objectId perhaps...
        
//        if let updateDatas = updateData as? [PFObject] {
//            println(updateData.objectId)
//            println(updateDatas)
//        }
        
//        println("The object ID is: \(updateData.objectId), homeboy.")
        


        
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
                        // if name is pulled
                        if let recipientName = object["firstName"] as? String {
                            self.authorNameLabel.text = recipientName
                        }
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
        
        let title:String? = (updateData as AnyObject)["method"] as? String
        let updateText:String? = (updateData as AnyObject)["life_difference"] as? String
        
        // get the date and format
        let date:String = (updateData as AnyObject)["date"] as! String
        var newDate = date.substringToIndex(advance(date.endIndex, -18))
        
        // assign labels and views
        self.updateTitleLabel.text = "via " + title!
        self.updateStoryLabel.text = updateText
        self.updateStoryLabel.sizeToFit()
        self.timestampLabel.text = newDate
        
//        self.likeButton.titleLabel!.text = String(numberOfLikes)
        self.likeButton.setTitle(toString(numberOfLikes), forState: UIControlState.Normal)
    }
}
