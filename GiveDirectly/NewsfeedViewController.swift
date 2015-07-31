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
    
    // This view controller may require a custom navigation, so a UIViewController was used instead of a UITableViewController,
    // which doesn't allow for resizing of the UITableView object.
    
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
    
    return 1
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let identifier = "UpdateTableViewCell_textonly"


    
    let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    println(indexPath.row)
    println(identifier)
    return cell
    
  }

  
}
