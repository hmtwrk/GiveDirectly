//
//  UserAccountTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/28/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      // autofit cells?
      tableView.estimatedRowHeight = 44
      tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 10
  }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
//    let identifier = indexPath.row == 0 ? "YourFriends" : "FriendActivityCell"
      
      let identifierArray = ["UserAccountProfileCell", "UserAccountStatsCell", "UserAccountFollowingCell", "YourFriends", "FriendActivityCell"]
      let identifier = indexPath.row < identifierArray.count ? identifierArray[indexPath.row] : "FriendActivityCell"
      
      println(identifier)
      let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        
      println(indexPath.row)
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
