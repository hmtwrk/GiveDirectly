//
//  NewsfeedViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/27/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class NewsfeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    // turn off the seam on the navigation bar for this page only
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    
    // turn off the cell separators
    //        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    //        self.tableView.separatorColor = UIColor.clearColor()
    
    // autofit cells
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 2
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var identifier = "UpdateTableViewCell_textonly"
    
    if indexPath.row == 1 {
      
      identifier = "UpdateTableViewCell_withphoto"
      
    }
    
    //    if indexPath.row == 2 {
    //
    //      identifier = "UpdateTableViewCell_notextnorphoto"
    //
    //    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    println(indexPath.row)
    println(identifier)
    return cell
    
  }

  
}
