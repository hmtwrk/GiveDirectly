//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class NewsfeedTableViewController: UITableViewController {
  
  var updateData = [AnyObject]()
  var numberOfUpdates = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // turn off the seam on the navigation bar for this page only
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    
    // autofit cells
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    
    //
    self.queryParseForNewsfeedUpdates()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return (numberOfUpdates)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let identifier = "UpdateTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    
    if let updateCell = cell as? UpdateTableViewCell {
      
//      println(updateData)
      let updateDataForCell: AnyObject = updateData[indexPath.row]
      updateCell.configureUpdateTableViewCell(updateDataForCell)
//      println(updateData.count)
      
    }
    
    return cell
    
  }
  
  func queryParseForNewsfeedUpdates() {
    
    // construct query to return target recipient
    let query:PFQuery = PFQuery(className: "RecipientUpdates")
    query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
      
      self.updateData = result!
      self.numberOfUpdates = result!.count
//      println(result!)
      self.tableView?.reloadData()
    }
  }
  
  
}
