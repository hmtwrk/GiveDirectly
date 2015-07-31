//
//  NewsfeedTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class old_UpdateTableViewCell: UITableViewCell {
  
  @IBOutlet weak var updateImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var topicLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var recipientStoryTextView: AutoTextView!
  @IBOutlet weak var numberOfCommentsLabel: UILabel!
  @IBOutlet weak var mostRecentCommentLabel: UILabel!

  
  func configureUpdateViewCell(updateDataForCell: AnyObject, commentDataForCell: AnyObject)
  {
    
    
    // recipientData is taken from the related data returned with updateDataForCell
    let recipientData:PFObject = (updateDataForCell["recipientName"] as? PFObject)!
//  let mostRecentCommentData:PFObject = (commentDataForCell as? PFObject)!
//    let author:PFObject = (mostRecentCommentData["author"] as? PFObject)!
//    var updateTimestamp:Int? = (updateDataForCell as AnyObject)["updatedAt"] as? Int
    let updateText:String? = (updateDataForCell as AnyObject)["updateText"] as? String
    let updateTopic:String? = (updateDataForCell as AnyObject)["updateTitle"] as? String
//    let commenterName = ((mostRecentCommentData as AnyObject)["author"] as? String)!
    let recipientName = ((recipientData as AnyObject)["name"] as? String)!
    let recipientProfilePhoto = recipientData["profileSquarePhoto"] as! PFFile
    let numberOfComments:Int? = commentDataForCell.count
    let mostRecentComment:NSString? = (commentDataForCell as AnyObject)["text"] as? NSString
//    let authorOfMostRecentComment:String? = (author as AnyObject)["nickname"] as? String
    
    var userCommentAuthorAttributes = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 12)!
    ]
    
    var userCommentTextAttributes = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!
    ]
    
    // TODO: need to adjust the green color to reflect the hex value
    var GDAuthorAttributes = [
      NSForegroundColorAttributeName: UIColor.greenColor(),
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 12)!
    ]
    
//    let pureComment = "\(authorOfMostRecentComment!) \(mostRecentComment!)"
//    let rangeLength = authorOfMostRecentComment?.length
//    let range = NSRange(location: 0, length: rangeLength!)
    var attributedComment = NSMutableAttributedString()
//    println("The author \(authorOfMostRecentComment!) has a nickname of \(rangeLength!) characters.")
    
//    attributedComment = NSMutableAttributedString(string: pureComment, attributes: userCommentTextAttributes)
//    attributedComment.addAttributes(userCommentAuthorAttributes, range: range)
//    attributedComment.addAttributes(GDAuthorAttributes, range: range)

    let updateID = updateDataForCell.objectId
    println(updateID)
    
    
    // load profile photo
    recipientProfilePhoto.getDataInBackgroundWithBlock({
      (imageData: NSData?, error: NSError?) -> Void in
      if (error == nil) {
        let image = UIImage(data: imageData!)
        self.updateImageView.image = image
      }
    })
    
    
    // assign labels and textviews
    self.nameLabel.text = recipientName
    self.timeLabel.text = "31m"
    self.topicLabel.text = updateTopic
    self.recipientStoryTextView.text = updateText
    self.mostRecentCommentLabel.attributedText = attributedComment
    
    
    // TODO: need to make the text display "0" if # of comments is nil
    if numberOfComments != nil {
      self.numberOfCommentsLabel.text = String(stringInterpolationSegment: numberOfComments!)
    }
    
    
    // make updater's profile image round... need to make this into its own class
    updateImageView.layer.cornerRadius = self.updateImageView.frame.size.width / 2
    updateImageView.clipsToBounds = true
    updateImageView.layer.borderWidth = 2.0
    updateImageView.layer.borderColor = UIColor.clearColor().CGColor
    updateImageView.layer.backgroundColor = UIColor.blackColor().CGColor
    
  }
  
}
