//
//  Update.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/8/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Parse

class Update : PFObject, PFSubclassing {
    
    // any variables you wish to access with dot notation
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var image: UIImage?
    
//    var likes = Dynamic<[PFUser]?>(nil)
    
    // MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "RecipientUpdates"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    
    
    // TODO: add a function that grabs the corresponding image data for recipient
    // "Adding Code to Display Images"
    // https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/custom-table-view-cell-post
}