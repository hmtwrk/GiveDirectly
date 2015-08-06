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
//    println(updateData)
    
    // configure outlets with Parse data
    let author:String? = (updateData as AnyObject)["gdid"] as? String
    let title:String? = (updateData as AnyObject)["goals"] as? String
    let updateText:String? = (updateData as AnyObject)["hardship"] as? String
    
    // assign labels and views
    self.authorNameLabel.text = author
    self.updateTitleLabel.text = title
    self.updateTextView.text = updateText
    self.timestampLabel.text = "1d"
    
    // make updater's profile image round...
    authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2
    authorImageView.clipsToBounds = true
    authorImageView.layer.borderWidth = 2.0
    authorImageView.layer.borderColor = UIColor.clearColor().CGColor
    authorImageView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
    
  }
  
  
}
