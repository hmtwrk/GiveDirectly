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
    
//    var updateData = [AnyObject]()
    var updates: [Update] = []
    var numberOfUpdates = Int()
    
    var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        self.queryParseForNewsfeedUpdates()
        ParseHelper.mostRecentUpdates {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            // cast results of API call into local data model (if can't cast, store as nil)
            self.updates = results as? [Update] ?? []
            
//            for update in self.updates {
//                
//                update["userHasLikedUpdate"] = update.userHasLikedUpdate
//
//            }
            
            // loop through each update
//            for update in self.updates {
//                let data = update.imageFile?.getData()
//                update.image = UIImage(data: data!, scale: 1.0)
//            }
            
//            print(self.updates)
            
            // assign results to local variables (can be optimized further)
//            self.updateData = self.updates
            self.numberOfUpdates = self.updates.count
//            print(self.updates)
            self.tableView?.reloadData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // remove the tab bar badge
        self.navigationController?.tabBarItem.badgeValue = nil
    }
    
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
        return (numberOfUpdates)
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
}

extension NewsfeedTableViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(1) {
            self.refreshView.endRefreshing()
            
            ParseHelper.mostRecentUpdates {
                (result: [AnyObject]?, error: NSError?) -> Void in
                self.updates = result as? [Update] ?? []
//                self.updateData = result!
                self.numberOfUpdates = result!.count
                self.tableView?.reloadData()
            }
            
        }
    }
}


// MARK: UpdateTableViewCellDelegate
extension NewsfeedTableViewController {
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: needs to change the data model from here, change visuals?
//        print(cell)
        
        // create a Liked object with the user's objectId
        // that points to the update (fromUser to likedPost)
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