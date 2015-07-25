//
//  MenuViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/20/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    var badge = UILabel(frame: CGRectMake(0, 0, 50, 14))
//    badge.center = CGPointMake(100, 100)
//    badge.textAlignment = NSTextAlignment.Center
//    badge.text = "I'm a test label."
//    self.view.addSubview(badge)
    
    
//    self.setNeedsStatusBarAppearanceUpdate()
    self.extendedLayoutIncludesOpaqueBars = true
    
    // rounded labels
//    portfolioBadgeLabel.layer.cornerRadius = 2.0
//    portfolioBadgeLabel.clipsToBounds = true
    
    // make updater's profile image round...
    // need to make this into its own class
    profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
    profileImageView.clipsToBounds = true
    profileImageView.layer.borderWidth = 2.0
    profileImageView.layer.borderColor = UIColor.clearColor().CGColor
    
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
//  override func preferredStatusBarStyle() -> UIStatusBarStyle {
//    return UIStatusBarStyle.LightContent
//  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  
}
