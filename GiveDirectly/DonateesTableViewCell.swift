//
//  DonateesTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class DonateesTableViewCell: UITableViewCell, UIScrollViewDelegate {
  
  @IBOutlet weak var recipientScrollView: UIScrollView!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    recipientScrollView.contentSize = CGSizeMake(400, 70)
    println("Hello there, you.")
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
