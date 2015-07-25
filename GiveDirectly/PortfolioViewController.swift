//
//  PortfolioViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/16/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // turn off the seam on the navigation bar for this page only
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    
    // configure custom button on navigation bar
//    var hamburger = UIImage(named: "menu_hamburger.pdf")
//    hamburger = hamburger?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//    let imageView = UIImageView(image: hamburger)
//    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: hamburger, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
  }
  

      


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
