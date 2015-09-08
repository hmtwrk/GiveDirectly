//
//  Like.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Parse

class Liked : PFObject, PFSubclassing {
    
    // default state = not liked
    var liked = false
    
    // allows changing of code that accesses properties through strings
    // example: post["imageFile"] = imageFile into: post.imageFile = imageFile
    @NSManaged var user: PFUser?
    
    // MARK: PFSubclassing Protocol
    
    // 3 — parseClassName creates a connection between Parse class and Swift class
    static func parseClassName() -> String {
        return "Liked"
    }
    
    // 4 — Parse boilerplate code that goes into any custom Parse class
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
    func toggleLiked() {
        liked = !liked
    }
    
    // TODO: make a Parse API call for creating or deleting a Liked object
    // TODO: make a Parse API call to check how many Users have liked the item
    // TODO: make a Parse API call to update the total number of likes an item has
}