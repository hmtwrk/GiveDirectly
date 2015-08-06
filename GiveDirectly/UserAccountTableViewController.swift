//
//  UserAccountTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/28/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UITableViewController {
    

    let identifierArray = ["UserAccountProfileCell", "UserAccountFollowingCell", "YourFriends", "FriendActivityCell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // autofit cells?
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // customize separators
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        


        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return identifierArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //    let identifier = indexPath.row == 0 ? "YourFriends" : "FriendActivityCell"
        
        
        let identifier = indexPath.row < identifierArray.count ? identifierArray[indexPath.row] : "FriendActivityCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        
        if let userProfileCell = cell as? UserAccountProfileTableViewCell {
//            userProfileCell.configureUserProfileCell(userData)
            let userData = PFUser.currentUser()
            userProfileCell.configureUserProfileCell(userData!)
        }
        
        if let userNetworkCell = cell as? UserAccountFollowingTableViewCell {
            userNetworkCell.configureYourNetworkCell()
        }
        
        if let recentActivityCell = cell as? RecentActivityTableViewCell {
            recentActivityCell.configureLatestActivityCell()
        }
        
//        println(indexPath.row)
        return cell
    }
    


    
}
