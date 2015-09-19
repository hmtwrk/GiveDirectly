//
//  Post.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/7/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Parse

// 1 — custom Parse class requires inheriting from PFObject and implementing PFSublassing protocol
class Post : PFObject, PFSubclassing {
    
    // 2 — define properties to access on this Parse class, 
    // allows changing of code that accesses properties through strings
    // example: post["imageFile"] = imageFile into: post.imageFile = imageFile
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var image: UIImage?
    
    // MARK: PFSubclassing Protocol

    // 3 — parseClassName creates a connection between Parse class and Swift class
    static func parseClassName() -> String {
        return "Post"
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
    
        
    func uploadPost() {
        
        // 1 — grab photo to be uploaded, then turn it into a PFFile
        let imageData = UIImageJPEGRepresentation(image!, 0.8)
        let imageFile = PFFile(data: imageData!)
        imageFile.saveInBackgroundWithBlock(nil)
        
        // associate any uploaded post with the current user
        user = PFUser.currentUser()
        
        // 2 — once imageFile is saved, assign it to self (Post being uploaded), then save() to store the Post
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)
    }
    
    //    func queryForTesting() {
    //        let postsQuery = Post.query()
    //        postsQuery?.whereKey("submittedBy", equalTo: PFUser.currentUser()!)
    //        postsQuery?.findObjectsInBackgroundWithBlock {
    //            (objects: [AnyObject]?, error: NSError?) -> Void in
    //            if error == nil {
    //
    //                // something worked
    //                println("Found \(objects!.count) matches! Hooray!")
    //
    //            } else {
    //
    //                // log details of the failure
    //                println("Error: \(error!) \(error!.userInfo!)")
    //            }
    //        }
    //        
    //    }
}