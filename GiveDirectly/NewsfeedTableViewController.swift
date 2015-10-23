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
        
        //        print(updates)
        
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
            
            // cast results of API call into local data model
            self.updates = results as? [Update] ?? []
            
            // update the data model for likes, comments
            for update in self.updates {
                
                // get like data for each recipient
                ParseHelper.fetchLikesForUpdate(update) {
                    (likes: [AnyObject]?, error: NSError?) -> Void in
                    
                    if let likes = likes {
                      
                        // update model with liked data
                        update.numberOfLikes = likes.count
                        
                        // see if user has liked the update
                        for like in likes {
                            
//                            print(like["fromUser"])
//                            print(PFUser.currentUser() == like["fromUser"] as? PFObject)
                        
                            if like["fromUser"] as? PFObject == PFUser.currentUser() {
                                update.userHasLikedUpdate = true
                            } else {
                                //
                            }
                            
                        }
                    }
                }
            }
            
            // reload tableView with Parse data
            self.tableView?.reloadData()
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView?.reloadData()
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
            
            // this bit is dependent on the includeKey data, and safe if nil
            let recipientData:PFObject? = updateDataForCell["recipientAuthor"] as? PFObject
            
            // TODO: add profile image to data model and cache locally?
            
            // following function takes an optional PFObject as a parameter
            ParseHelper.recipientImagesForCell(cell, withRecipientData: recipientData, orUpdateData: updateDataForCell)
            
//            print(updateDataForCell)
            
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
        delayBySeconds(1.5) {
            self.refreshView.endRefreshing()
            
            //            ParseHelper.mostRecentUpdates {
            //                (result: [AnyObject]?, error: NSError?) -> Void in
            //                self.updates = result as? [Update] ?? []
            //                self.tableView?.reloadData()
            //            }
            
            // Parse API call for recent updates, with completion block
            ParseHelper.mostRecentUpdates {
                (results: [AnyObject]?, error: NSError?) -> Void in
                
                
                // cast results of API call into local data model (seems impossible to fail cast)
                self.updates = results as? [Update] ?? []
                
                // reload tableView with Parse data
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
            
            // call Parse function to like update
            ParseHelper.likeUpdate(PFUser.currentUser()!, update: update)
            
        } else {
            update.numberOfLikes -= 1
            
            // call Parse to unlike update
            ParseHelper.unlikeUpdate(PFUser.currentUser()!, update: update)
        }
        
        // update the view cell
        cell.configureLikeForCell(update)
        
        // display status of data model in console (for testing)
//        for update in updates {
//            print(update.userHasLikedUpdate)
//        }
//        print("==========")
        
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