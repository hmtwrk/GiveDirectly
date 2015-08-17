//
//  UpdateTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var updateTitleLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var updateTextView: UITextView!
  @IBOutlet weak var numberOfLikesLabel: UILabel!
  @IBOutlet weak var numberOfComments: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    
  }
  
  
  func configureUpdateTableViewCell(updateData: AnyObject) {
    
    // have to get the updateData[indexPath.row] in table view controller for subscripting to work like below...
    
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
                    // TODO: create optional else statement
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
    self.updateTextView.text = updateText
    self.timestampLabel.text = newDate
  }
}
