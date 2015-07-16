//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class NewsfeedTableViewController: UITableViewController {
  
  // initialize variable to accept Parse update data
  var recipientUpdates = [AnyObject]()
  var numberOfUpdates = Int()
  var updateData: [AnyObject] = []
  var commentData: [AnyObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // turn off the seam on the navigation bar for this page only
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    
    // turn off the cell separators
    //        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    //        self.tableView.separatorColor = UIColor.clearColor()
    
    // autofit cells?
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // fetch the data for the newsfeed cells
    self.queryParseForNewsfeedUpdates()
    
    
    
  }
  
  override func viewDidAppear(animated: Bool) {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of rows in the section.
    numberOfUpdates = self.updateData.count
    return (numberOfUpdates)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let identifier = "UpdateTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
    
    if let update = cell as? UpdateTableViewCell {
      
      // sends each cell to its row, starting with newest update
      let updateDataForCell: AnyObject = updateData[indexPath.row]
      // updateDataForCell["recipientName"] as? PFObject
      
      // "recipientInfo" is a relational lookup on the recipient's name
      // can't I just put this code in the cell itself, without assigning to new variables?
      let recipientDataForCell = updateDataForCell["recipientName"] as? PFObject
      
      //            println(recipientInfo!)
      
      //
      let commentDataForCell: AnyObject = commentData
      
      
      //      println(commentDataForCell)
      //      println(commentData)
      //            let commentDataForCell: AnyObject = commentData
      
      
      
      
      // when indexPath.row is finished, reload tableView?
      
      
      
      
      
      //            self.queryParseForRelatedComments(updateInfo)
      
      // configure the cell with the comment info
      //            update.configureCommentsWithParse(updateInfo)
      
      //            self.queryParseForRelatedComments(object)
      
      //            let recipientInfo: AnyObject = recipientUpdates[indexPath.row]
      
      //      update.configureUpdateViewCell(updateDataForCell, recipientDataForCell: recipientDataForCell!, commentDataForCell: commentDataForCell)
      update.configureUpdateViewCell(updateDataForCell, commentDataForCell: commentDataForCell)
    }
    
    
    return cell
    
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "CommentSegue" {
      let toView = segue.destinationViewController as! CommentViewController
      let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
      let updateInfo: (AnyObject) = updateData[indexPath!.row]
      let recipientInfo = updateInfo["recipientName"] as? PFObject
      
      toView.updateInfo = updateInfo
      toView.recipientInfo = recipientInfo!
    }
  }
  
  
  func queryParseForNewsfeedUpdates() {
    
    // here is the query for the update text, but need to fetch the "recipientName" pointer,
    // which points to the "Recipients" class, and fetch the data from "name" and "profileSquarePhoto"
    
    
    // 3 —— combine the two queries into one variable for network call
    //        let query = PFQuery.orQueryWithSubqueries([recipientUpdateQuery, relatedComments])
    //        query.orderByDescending("createdAt")
    
    
    // 1 —— retrieve the RecipientUpdates and all the corresponding biodata (recipient's name, timestamp, etc.)
    // For now, just retrieve "Everyone"
    
    //        recipientUpdate.whereKey("recipientName", equalTo: PFObject(withoutDataWithClassName: "Recipients", objectId: "st3hctPPFb"))
    //        recipientUpdate.whereKey("objectId", equalTo: "xPSyiLfMJ8")
    
    
    
    
    let recipientUpdate:PFQuery = PFQuery(className: "RecipientUpdate")
    
    // this particular post has five comments...
//    recipientUpdate.whereKey("objectId", equalTo: "xPSyiLfMJ8")
//    recipientUpdate.whereKey("objectId", equalTo: "NcLyy3pUv7")
    
    // the following post has zero comments...
    recipientUpdate.whereKey("objectId", equalTo: "h2dIPMHfCL")
    
    recipientUpdate.orderByDescending("createdAt")
    // recipientUpdate retrieves all the updates (around ten), and includes the biodata for each recipient (includeKey)
    recipientUpdate.includeKey("recipientName")
    
    let relatedComments:PFQuery = PFQuery(className: "Comments")
    relatedComments.whereKey("relatedUpdate", matchesQuery: recipientUpdate)
    relatedComments.orderByDescending("createdAt")
    relatedComments.includeKey("author")
    
    recipientUpdate.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
      
      self.updateData = result!
      println("Doth any error exist? It's \(error).")
      println(self.updateData)
      
      
      
      relatedComments.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
        
        println("Within empty comments, doth any result exist? \(result!).")
        
        
        
        
        // need to check if the comment is empty, and do something... maybe append to the updateData var?
        
        
        
        
//        if result!.isEmpty {
////          println(result![0])
          self.commentData = result!
//          self.commentData = []
//          println("It's empty, yo.")
//          println(self.commentData)
//          self.updateData.append([])
//          println(self.updateData)
//        } else {
////          println(result![0])
//          self.commentData = result!
//        }
        
//        println(result!)
        
        
        
        self.tableView.reloadData()
        
        
        
      } // end of nested API call (for comments)
    } // end of first API call (for updates)
  }
  
  
  
  
  
}