//
//  RecipientRelatedUpdateCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/31/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

protocol RecipientRelatedUpdateCellDelegate: class {
    
    func relatedUpdateCellLikeButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject)
    func relatedUpdateCellCommentButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject)
    func relatedUpdateCellExtraButtonDidTap(cell: RecipientRelatedUpdateCell, sender: AnyObject)
}

class RecipientRelatedUpdateCell: UITableViewCell {
    
    
    // this information needs to be moved to the data source
    var hasLikedUpdate = false
    
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
    
    
    weak var delegate: RecipientRelatedUpdateCellDelegate?
    
    // TODO: assign Parse data to numberOfLikesLabel and numberOfCommentsLabel
    // TODO: configure labels for number of likes and comments


    // MARK: SpringButton functionality
    @IBAction func likeButtonDidTap(sender: AnyObject) {
        
        if hasLikedUpdate == false {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes += 1
            self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
            
        } else {
            self.likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
            self.numberOfLikes -= 1
            self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
        }
        
        hasLikedUpdate = !hasLikedUpdate
        print(hasLikedUpdate)
        
        
        delegate?.relatedUpdateCellLikeButtonDidTap(self, sender: sender)
        
    }
    
    @IBAction func commentButtonDidTap(sender: AnyObject) {
        
        delegate?.relatedUpdateCellCommentButtonDidTap(self, sender: sender)
    }
    
    @IBAction func extraButtonDidTap(sender: AnyObject) {
        
        delegate?.relatedUpdateCellExtraButtonDidTap(self, sender: sender)
    }
    
    // MARK: configuration of cell
    func configureUpdateTableViewCell(recipientName: String, updateData: AnyObject) {
        
//        println(updateData)
        
        let title:String? = (updateData as AnyObject)["method"] as? String
        let updateText:String? = (updateData as AnyObject)["life_difference"] as? String
        
        // configure outlets with Parse data
        let author:String! = (updateData as AnyObject)["GDID"] as! String
        // check Recipients class to mine information
        let query = PFQuery(className:"Recipients")
        query.whereKey("gdid", equalTo: author)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // check to see if something exists
                if let objects = objects as? [PFObject] {
//                    println("There are \(objects.count) objects.")
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
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

        
        // get the date and format
        let date:String = (updateData as AnyObject)["date"] as! String
        let newDate = date.substringToIndex(date.endIndex.advancedBy(-18))
        
        // assign labels and views
        self.authorNameLabel.text = recipientName
        self.updateTitleLabel.text = title!
        self.updateStoryLabel.text = updateText
        self.updateStoryLabel.sizeToFit()
        self.timestampLabel.text = newDate
        
        //        self.likeButton.titleLabel!.text = String(numberOfLikes)
        self.likeButton.setTitle(String(numberOfLikes), forState: UIControlState.Normal)
        
        
        
    }



}