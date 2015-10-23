//
//  Recipients.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

class Recipient {
    
    // TODO: Alamofire JSON-compatible
    var recipientData: JSON
    var recipientInfo: [AnyObject]
    var caption: String
    var comment: String
    var image: UIImage
    
    init(recipientData: JSON, recipientInfo: [AnyObject], caption: String, comment: String, image: UIImage) {
        self.recipientData = recipientData
        self.recipientInfo = recipientInfo
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let recipientData = dictionary["Data"] as? JSON
        let recipientInfo = dictionary["Recipient"] as? [AnyObject]
        let caption = dictionary["Caption"] as? String
        let comment = dictionary["Comment"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(recipientData: recipientData!, recipientInfo: recipientInfo!, caption: caption!, comment: comment!, image: image!)
    }
    
    class func queryParseForRecipients() {
        
        
        // Parse API call to return target recipient
        let query:PFQuery = PFQuery(className: "Recipients")
        query.orderByAscending("createdAt")
        
        // query.limit = 20 (default = 100)
        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
            recipientBrowserData = result!
            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
    }
    
    class func retrieveJSON() {
        
        // AlamoFire requests
        let user = "admin"
        let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print("Base64 credentials:\(base64Credentials).")
        
        
        // Get a list of all recipients (the "recipients" key will hold an array of GDID objects)
        let constraint = "?sort=enrollDate&order=desc&limit=20" // set amount of recipients to return
        let url = "https://mobile-backend.givedirectly.org/api/v1/recipients/" + constraint
        
        // API call... need to 
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                // let json = response.result.value as! NSDictionary
                if let value: AnyObject = response.result.value {
                    let json = JSON(value)
//                    print(json)
                    print(json["recipients"].count) // 100 recipients
//                    print(json["recipients"][0]["firstName"]) // drill down into JSON
                    
                    let idArray = json["recipients"]
                    print("There are \(idArray.count) items in the idArray.")
                    
                    dynamicRecipientData = json
//                    print(dynamicRecipientData)
                    
                    // extract all GDIDs from dictionary
//                    for index in 0..<idArray.count {
                    
                        // assemble URL
//                        let gdid = idArray[index].string!
//                        let url = "https://mobile-backend.givedirectly.org/api/v1/recipients/" + gdid
//                        print(url)
                        
                        // API call to fetch records
//                        Alamofire.request(.GET, url, headers: headers)
//                            .responseJSON { response in
//                                if let value: AnyObject = response.result.value {
//                                    let json = JSON(value)
//                                    dynamicRecipientData.append(json)
//                                    //                                    print(json)
//                                    print(dynamicRecipientData.count)
//                                }
//                        }
//                    }
                    
                    
                    
                }
                
//                print(dynamicRecipientData.count)
//                print("Prepare to reload.")
                NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
    }
}