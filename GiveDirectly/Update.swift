//
//  Update.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/8/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Parse
import Alamofire

class Update: PFObject, PFSubclassing {
    
    // any variables you wish to access with dot notation
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var image: UIImage?
    
    // doesn't seem like these properties are taking effect?
    var userHasLikedUpdate = false
    var numberOfLikes = 0
    
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
    
    // TODO: pass completion block as parameter, to be handled in newsfeed view controller
    class func retrieveUpdates(completionBlock: (NSDictionary?, NSError?) -> () ) {
        
        // AlamoFire requests
        let user = "admin"
        let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print("Base64 credentials:\(base64Credentials).")
        
        // Get a list of all recipients (the "recipients" key will hold an array of GDID objects)
//        let constraint = "?sort=order=desc&limit=20" // set amount of recipients to return
//        let constraint = ""
        let url = "https://mobile-backend.givedirectly.org/api/v1/users/SUPERADMINISTRATOR"
        
        // API call
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
    

    
    // TODO: add a function that grabs the corresponding image data for recipient
    // "Adding Code to Display Images"
    // https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/custom-table-view-cell-post
}