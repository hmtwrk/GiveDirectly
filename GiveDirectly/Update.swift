//
//  Update.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/8/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Alamofire

class Update {
    
    var image: UIImage?
    
    // doesn't seem like these properties are taking effect?
    var userHasLikedUpdate = false
    var numberOfLikes = 0
    
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
        let url = "https://mobile-backend.givedirectly.org/api/v1/users/SUPERADMINISTRATOR?limit=20"
        
        // API call
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
}