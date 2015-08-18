//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class NewsfeedTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
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
}

// MARK: - Table View Data Source
extension NewsfeedTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (numberOfUpdates)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        if let updateCell = cell as? UpdateTableViewCell {
            let updateDataForCell: AnyObject = updateData[indexPath.row]
            updateCell.configureUpdateTableViewCell(updateDataForCell)
        }
        
        return cell
    }
    
    func queryParseForNewsfeedUpdates() {
        
        // construct query to return target recipient
        let query:PFQuery = PFQuery(className: "RecipientUpdates")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
            self.updateData = result!
            self.numberOfUpdates = result!.count
            self.tableView?.reloadData()
        }
    }
}

// MARK: UpdateTableViewCellDelegate
extension NewsfeedTableViewController: UpdateTableViewCellDelegate {
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement like functionality
        
        // create a Liked object with the user's objectId
        // that points to the update (fromUser to likedPost)
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement comment functionality
        
        // create a Comment object with the user's objectId
        // that points to the update (author to relatedUpdate with text)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}