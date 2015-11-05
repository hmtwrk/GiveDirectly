//
//  UserAccountTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/28/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UITableViewController {
    
    var displayDonationTracker = false
    var userJSON: JSON = []
    
    let identifierArray = ["UserAccountProfileCell", "UserAccountFollowingCell", "YourFriends", "FriendActivityCell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // autofit cells?
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // customize separators
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // retrieve user object from backend
        User.retrieveUser() { responseObject, error in
            
            if let value: AnyObject = responseObject {
                let json = JSON(value)
                self.userJSON = json
                self.tableView?.reloadData()
            }
        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // refresh the Parse current user cache and reload tableView
//        let currentUser = PFUser.currentUser()
//        currentUser?.fetchInBackgroundWithBlock { (object, error) -> Void in
//            
//            // reload the tableView so that the data is current
//            print("Matrix reloaded!")
//            self.tableView?.reloadData()
//            
//            // remove the tab bar badge
//            self.navigationController?.tabBarItem.badgeValue = nil
//            
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        return identifierArray.count
        return 4
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //    let identifier = indexPath.row == 0 ? "YourFriends" : "FriendActivityCell"
        
        // TODO: modify this logic so that numerous update cells can be appended to the bottom of the view
        // (first three cells are static, whereas cells >= [3] are dynamic newsfeed items
        let identifier = indexPath.row < identifierArray.count ? identifierArray[indexPath.row] : "FriendActivityCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        
        if let userProfileCell = cell as? UserAccountProfileTableViewCell {
//            let userData = PFUser.currentUser()
            let userData = userJSON["user"]
            
            // the userData! syntax might be causing random crashes
            userProfileCell.configureUserProfileCell(userData, willShowDonationTracker: showDonationTracker)
        }
        
        if let userNetworkCell = cell as? UserAccountFollowingTableViewCell {
            userNetworkCell.configureYourNetworkCell()
        }
        
        if let recentActivityCell = cell as? RecentActivityTableViewCell {
            recentActivityCell.configureLatestActivityCell()
        }
        
        return cell!
    }
    
    
    
    
}
