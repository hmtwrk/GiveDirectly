//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

private let refreshViewHeight: CGFloat = 200

// leftover code from demo, which might be useful (delay for pull-to-refresh)
func delayBySeconds(seconds: Double, delayedCode: ()->() ) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}

class NewsfeedTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    var updates: [Update] = []
    var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull-to-refresh code
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(view.bounds), height: refreshViewHeight), scrollView: tableView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.delegate = self
        view.insertSubview(refreshView, atIndex: 0)
        
        // turn off the seam on the navigation bar for this page only
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        // autofit cells
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Parse API call for recent updates, with completion block
        ParseHelper.mostRecentUpdates {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            // cast results of API call into local data model (seems impossible to fail cast)
            self.updates = results as? [Update] ?? []
            
            // append dictionary entry for data model's liked status
            for update in self.updates {
                update["userHasLikedUpdate"] = update.userHasLikedUpdate
            }
            
            // reload tableView with Parse data
            self.tableView?.reloadData()
        }
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //
    //        // remove the tab bar badge
    //        self.navigationController?.tabBarItem.badgeValue = nil
    //    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

// MARK: - Table View Data Source
extension NewsfeedTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (updates.count)
    }
 
    // tableView:cellForRowAtIndexPath gets called every time a cell is queued,
    // so the functions inside need to update the cell with the most current
    // data from the model (configureLike, etc)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        // cast to specific class
        if let cell = cell as? UpdateTableViewCell {
            
            // mine specific data to pass to cell
            let updateDataForCell: AnyObject = self.updates[indexPath.row]
            
            // this bit is dependent on the includeKey data
            // TODO: make safe for nil case (following code should work)
//                        let recipientDataForCell:PFObject? = updateDataForCell["recipientAuthor"] as? PFObject
            
            // download corresponding recipient image for each cell
            // TODO: add profile image to data model and cache locally?
            let recipientData = updateDataForCell["recipientAuthor"] as! PFObject
            ParseHelper.recipientImagesForCell(cell, withRecipientData: recipientData)
 
            // configure queued cell with newest data from model
            cell.configureUpdateTableViewCell(updateDataForCell)
            cell.configureLikeForCell(updateDataForCell as! Update)
            cell.delegate = self
        }
        return cell!
    }
}

extension NewsfeedTableViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(2) {
            self.refreshView.endRefreshing()
            
            ParseHelper.mostRecentUpdates {
                (result: [AnyObject]?, error: NSError?) -> Void in
                self.updates = result as? [Update] ?? []
                self.tableView?.reloadData()
            }
        }
    }
}

// MARK: UpdateTableViewCellDelegate
extension NewsfeedTableViewController {
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        // update the data model with liked status (has liked, increment # of likes)
        let indexPath = tableView.indexPathForCell(cell)
        let update = updates[indexPath!.row]

        // toggle status of like
        update.userHasLikedUpdate = !update.userHasLikedUpdate
        
        // increment or decrement total likes
        if update.userHasLikedUpdate {
            update.numberOfLikes += 1
        } else {
            update.numberOfLikes -= 1
        }
        
        // update the view cell
        cell.configureLikeForCell(update)

        // display status of data model in console (for testing)
        for update in updates {
            print(update.userHasLikedUpdate)
        }
        print("==========")
   
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement comment functionality
        // needs to have the row and etc.
        
        
        // create a Comment object with the user's objectId
        // that points to the update (author to relatedUpdate with text)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}