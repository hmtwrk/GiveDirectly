//
//  NewsfeedTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var updateImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recipientStoryTextView: AutoTextView!
    
    var commentInfo = [PFObject]()
    
    override func awakeFromNib() {
        
        // this is where the cell should query for related comments
//        println("This cell was loaded.")

        
    }
    
    
    
    func configureUpdateViewCell(updateInfo: AnyObject, recipientInfo: PFObject) {
    
//        println(updateInfo)
//        println(recipientInfo)

        
//        var updateTimestamp:Int? = (updateInfo as AnyObject)["updatedAt"] as? Int
        let updateText:String? = (updateInfo as AnyObject)["updateText"] as? String
        let updateTopic:String? = (updateInfo as AnyObject)["updateTitle"] as? String
        let recipientName:String? = (recipientInfo as AnyObject)["name"] as? String
        let recipientProfilePhoto = recipientInfo["profileSquarePhoto"] as! PFFile
        
        // get comments
        let updateID = updateInfo.objectId
//        println(updateID)
        
        
        
        
//        let query = PFQuery(className: "Comments")
//        query.whereKey("relatedUpdate", equalTo: PFObject(withoutDataWithClassName: "RecipientUpdate", objectId: updateID))
//        query.orderByDescending("createdAt")
//        query.limit = 1
//        query.findObjectsInBackgroundWithBlock {
//            (comments: [AnyObject]?, error: NSError?) -> Void in
//            
//            println(comments)
//            self.reloadInputViews()
//        
//        }
        
        
        


        
        
        // load profile photo
        recipientProfilePhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.updateImageView.image = image
            }
        })
        
        
//        self.taglineLabel.text = "\(recipientName) via \(GDsubmitter)"
//        self.taglineLabel.text = "\(recipientName)"
        self.nameLabel.text = recipientName
        self.timeLabel.text = "31m"
        self.topicLabel.text = updateTopic
        self.recipientStoryTextView.text = updateText

        // make updater's profile image round
        updateImageView.layer.cornerRadius = self.updateImageView.frame.size.width / 2
        updateImageView.clipsToBounds = true
        updateImageView.layer.borderWidth = 2.0
        updateImageView.layer.borderColor = UIColor.clearColor().CGColor
        updateImageView.layer.backgroundColor = UIColor.blackColor().CGColor
        
    }

}
