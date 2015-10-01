//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

private let refreshViewHeight: CGFloat = 200

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
        
        // pull-to-refresh
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
            
            // cast results of API call into local data model (if can't cast, store as nil... but always seems to work)
            // does this block need to iterate through the individual updates?
            self.updates = results as? [Update] ?? []
            
            for update in self.updates {
                
                update["userHasLikedUpdate"] = update.userHasLikedUpdate

            }
            
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Table View Data Source
extension NewsfeedTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (updates.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if let updateCell = cell as? UpdateTableViewCell {
            
            //            let updateDataForCell: AnyObject = updateData[indexPath.row]
            let updateDataForCell: AnyObject = self.updates[indexPath.row]
            
            // this bit is dependent on the includeKey data
            // TODO: make safe for nil
            let recipientDataForCell = updateDataForCell["recipientAuthor"] as! PFObject
            
            // safely pull images without a crash...
            if let recipientProfilePhoto = recipientDataForCell["image"] as? PFFile {
                recipientProfilePhoto.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data: imageData!)
                        updateCell.authorImageView.image = image
                        updateCell.authorImageView.layer.cornerRadius = updateCell.authorImageView.frame.size.width / 2
                        updateCell.authorImageView.clipsToBounds = true
                    } else {
                        // there was an error
                        print("There was an error of \(error).")
                    }
                }
            } else {
                
                // should be working, but not?
                // TODO: figure out why not
                updateCell.authorImageView.backgroundColor = UIColor.blackColor()
                updateCell.authorImageView.image = UIImage(named: "smallBlankProfileImage.pdf")
                updateCell.authorImageView.layer.cornerRadius = updateCell.authorImageView.frame.size.width / 2
                updateCell.authorImageView.clipsToBounds = true
                print("Update item does not have a profile photo.")
            }
            
            //            updateCell.configureUpdateTableViewCell(updateDataForCell, recipientDataForCell: recipientDataForCell)
            
            updateCell.configureUpdateTableViewCell(updateDataForCell)
            updateCell.delegate = self
        }
        return cell!
    }
    
    func configureLikeForCell(cell: UpdateTableViewCell, withUpdate: Update) {
        
        let likeButton = cell.likeButton as UIButton
        
        likeButton.setTitle(String(withUpdate.numberOfLikes), forState: UIControlState.Normal)
        
        if withUpdate.userHasLikedUpdate {
            // change the image
            likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
            
        } else {
            // image is hollow with unchanged count
            likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
        }
        
    }
}

extension NewsfeedTableViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(1) {
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
        
        // increment or decrement
        if update.userHasLikedUpdate {
            update.numberOfLikes += 1
        } else {
            update.numberOfLikes -= 1
        }
        
        
        self.configureLikeForCell(cell, withUpdate: update)
        
        //        if update.userHasLikedUpdate {
        //
        //            // toggle settings to has liked
        //            update.numberOfLikes += 1
        //            cell.likeButton.setImage(UIImage(named: "icon_thumbsup-selected.pdf"), forState: UIControlState.Normal)
        //
        //        } else {
        //
        //            // toggle settings to not liked
        //            update.numberOfLikes -= 1
        //            cell.likeButton.setImage(UIImage(named: "icon_thumbsup.pdf"), forState: UIControlState.Normal)
        //        }
        
        //        cell.likeButton.setTitle(String(cell.numberOfLikes), forState: UIControlState.Normal)
        //        update["userHasLiked"] = update.userHasLikedUpdate
        
        // check
        
        for update in updates {
            print(update.userHasLikedUpdate)
        }
        print("==========")
        
//        print("From data model: \(update.userHasLikedUpdate).")
//        print("Number of likes: \(update.numberOfLikes).")
        
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