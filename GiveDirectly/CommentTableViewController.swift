//
//  CommentTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 11/17/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    // variable to hold passed info from segue
    var update: Update = Update()
    var comments: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // autofit cells
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // turn off the seam on the navigation bar for this page only
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        // turn off the empty cell footers
        self.tableView.tableFooterView = UIView()
        
        // TODO: make an API call for total number of comments associated with the newsfeed object
    }
    
    // MARK: tableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // first section: original newsfeed item
        // second section: list of associated comments
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // the first section will have just the one newsfeed item; the second section will vary
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if let cell = cell as? UpdateTableViewCell {
            
            // download image from cache / Alamofire
            //            GDService.downloadImage(recipientImageURL) { data in
            //
            //                let image = UIImage(data: data)
            //                cell.authorImageView.image = image
            //            }
            
            
            // send data to cell
            cell.configureUpdateTableViewCell(update)
            cell.delegate = self
            
            // download associated image for cell
            //            GDService.downloadImage(recipientImageURL) { data in
            //
            //                let image = UIImage(data: data)
            //                cell.authorImageView.image = image
            //
            //            }
        }
        
        return cell
        
    }
}

// MARK: UpdateTableViewCellDelegate
extension CommentTableViewController {
    
    func recipientImageDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        print("Well, howdy do!")
        performSegueWithIdentifier("NewsfeedProfileSegue", sender: cell)
    }
    
    func updateLikeButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        
        
    }
    
    func updateCommentButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    func updateExtraButtonDidTap(cell: UpdateTableViewCell, sender: AnyObject) {
        // TODO: implement extra functionality
        
        // open a view that allows user to report, share, etc.
    }
    
}
