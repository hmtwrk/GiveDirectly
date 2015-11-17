//
//  CommentTableViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 11/17/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {
    
    // variable to hold passed info from segue
    var update: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(update)
    }
}
