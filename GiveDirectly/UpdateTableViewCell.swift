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
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var extraButton: UIButton!
    

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


        
        // TODO: create unique image for "already liked" icon, and tweak animation timing
        if userHasLikedPost == false {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes += 1
            self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
            
        } else {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes -= 1
            self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
        }
        
        userHasLikedPost = !userHasLikedPost
        print(userHasLikedPost)

        
        delegate?.updateLikeButtonDidTap(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        delegate?.updateCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        delegate?.updateExtraButtonDidTap(self, sender: sender)
    }
    

    
    // MARK: configuration of cell
//    func configureUpdateTableViewCell(updateData: AnyObject, recipientDataForCell: PFObject) {
    func configureUpdateTableViewCell(updateData: AnyObject) {
    
        // check what's coming to the cell
//        print(recipientDataForCell)
//        print(updateData)
        
        // change this to if let
        let recipientData:PFObject = (updateData["recipientAuthor"] as? PFObject)!
//        print(recipientData)
        
        
        
        
        // configure outlets with Parse data
//        let author:String! = (updateData as AnyObject)["GDID"] as! String
        
        // check Recipients class to mine information
//        let query = PFQuery(className:"Recipients")
//        query.whereKey("gdid", equalTo: author)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                
//                // check to see if something exists
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//
//                        // if name is pulled
//                        if let recipientName = object["firstName"] as? String {
//                            self.authorNameLabel.text = recipientName
//                        }
//                        // if image is pulled
//                        if let recipientProfilePhoto = object["image"] as? PFFile {
//                            recipientProfilePhoto.getDataInBackgroundWithBlock {
//                                (imageData: NSData?, error: NSError?) -> Void in
//                                if (error == nil) {
//                                    let image = UIImage(data: imageData!)
//                                    self.authorImageView.image = image
//                                    self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
//                                    self.authorImageView.clipsToBounds = true
//                                }
//                            }
//                        }
//                    }
//                }
//            } else {
//                
//                // log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
        
        // load an image
        if let recipientProfilePhoto = recipientData["image"] as? PFFile {
            recipientProfilePhoto.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    self.authorImageView.image = image
                    self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
                    self.authorImageView.clipsToBounds = true
                }
            }
        } else {
            self.authorImageView.image = UIImage(named: "blankProfileImage")
            self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
            self.authorImageView.clipsToBounds = true
        }
        
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
        
        // load image... move elsewhere eventually
//        let image = UIImage(data: imageData!)
//        self.authorImageView.image = image
//        self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
//        self.authorImageView.clipsToBounds = true
        
//        self.likeButton.titleLabel!.text = String(numberOfLikes)
        self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
    }
}
