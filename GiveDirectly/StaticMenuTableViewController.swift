//
//  StaticMenuTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/25/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class StaticMenuTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // customize separators
    self.tableView.tableFooterView = UIView(frame: CGRectZero)
    self.tableView.preservesSuperviewLayoutMargins = false
    self.tableView.layoutMargins = UIEdgeInsetsZero
    self.tableView.separatorInset = UIEdgeInsetsZero
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsetsZero
  }
  

  
  
}
