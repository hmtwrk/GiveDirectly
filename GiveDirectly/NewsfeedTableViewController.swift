//
//  NewsfeedTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/30/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

private let refreshViewHeight: CGFloat = 200

// leftover code from demo, which might be useful (delay for pull-to-refresh)
func delayBySeconds(seconds: Double, delayedCode: ()->() ) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}

class NewsfeedTableViewController: UITableViewController, UpdateTableViewCellDelegate {
    
    var recipients: JSON = []
    var updates: JSON = []
//    var updates: [Update] = []
//    var likes: [Liked] = [] // is it necessary to have an array of likes?
    var refreshView: RefreshView!
//    var updatesJSON: JSON = []
    var updatesList: [JSON] = []
    var recipientInfoForSegue: JSON = []
    
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
        
        // API call to return related recipient objects
        GDService.profilesForRecipients() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                self.recipients = json["recipients"]
            }
        }

        // API call to return newsfeed objects
        GDService.updatesForNewsfeed() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                self.updates = json["newsfeeds"]
                self.attachRecipientDataToUpdates()
                self.tableView?.reloadData()
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

// MARK: - Table View Data Source
extension NewsfeedTableViewController {
    
    // append recipient data to corresponding newsfeed objects
    func attachRecipientDataToUpdates() {

        // iterate through each update and extract GDID
        for update in 0..<updates.count {
            
            let gdid = updates[update]["gdid"].string ?? ""
            print("Thy GDID is: \(gdid)!")
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.updates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UpdateTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        // cast to specific class
        if let cell = cell as? UpdateTableViewCell {
            
//            let updateDataForCell: JSON = self.updates[indexPath.row]
//            let recipientImageURL = self.updatesList[indexPath.row]["recipientAvatar"].string ?? ""
            
            // download associated image for cell
//            GDService.downloadImage(recipientImageURL) { data in
//                
//                let image = UIImage(data: data)
//                cell.authorImageView.image = image
//                
//            }
            
            // configure queued cell with newest data from model
//            cell.configureUpdateTableViewCell(updateDataForCell)
            cell.delegate = self
        }
        return cell
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        // segue from newsfeed item to recipient profile view
//        if segue.identifier == "NewsfeedProfileSegue" {
//            let toView = segue.destinationViewController as! RecipientProfileTableViewController
//            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
//            var recipientInfo = updatesList[indexPath!.item]
//            self.matchUpdateWithRecipientGDID(recipientInfo["biodata"]["gdid"].string!)
////            print(recipientInfoForSegue)
//            toView.recipientInfo = recipientInfoForSegue
//        }
        
        // segue from comment to expanded comment view
//        if segue.identifier == "CommentsSegue" {
//            let toView = segue.destinationViewController as! CommentTableViewController
//            let indexPath = tableView?.indexPathForCell(sender as! UITableViewCell)
//            let selectedUpdate = updatesList[indexPath!.item]
//            //            print(selectedUpdate)
//            toView.update = selectedUpdate
//        }
//    }
}

extension NewsfeedTableViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(1.5) {
            
            self.refreshView.endRefreshing()
            
            // TODO: make an Alamofire refresh with completion block
        }
    }
}

// MARK: UpdateTableViewCellDelegate
extension NewsfeedTableViewController {
    
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