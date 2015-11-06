//
//  User.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 11/5/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

class User {

    class func retrieveUser(completionBlock: (NSDictionary?, NSError?) -> () ) {
        
        // AlamoFire requests
        let user = "admin"
        let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print("Base64 credentials:\(base64Credentials).")
        
        // Get a list of all recipients (the "recipients" key will hold an array of GDID objects)
        let constraint = "SUPERADMINISTRATOR" // set amount of recipients to return
//        let constraint = "?filter=firstName%3DSean"
        let url = "https://mobile-backend.givedirectly.org/api/v1/users/" + constraint
        
        // API call
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
        
    }
    
//    class func downloadImageWithURL(url: String, andCompletionBlock completionBlock: (NSDictionary?, NSError?) -> () ) {
//        
//        let user = "admin"
//        let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
//        
//        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
//        
//        let headers = ["Authorization": "Basic \(base64Credentials)"]
//        
//        // API call
//        Alamofire.request(.GET, url, headers: headers).response() {
//            (_, _, data, _) in
//        
//                completionBlock(responseObject.result.value as? NSData, response.result.error)
//        }
//    }
}
