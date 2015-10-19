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
    
    var recipientInfo: [AnyObject]
    var caption: String
    var comment: String
    var image: UIImage
    
    init(recipientInfo: [AnyObject], caption: String, comment: String, image: UIImage) {
        self.recipientInfo = recipientInfo
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let recipientInfo = dictionary["Recipient"] as? [AnyObject]
        let caption = dictionary["Caption"] as? String
        let comment = dictionary["Comment"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(recipientInfo: recipientInfo!, caption: caption!, comment: comment!, image: image!)
    }
    
    class func queryParseForRecipients() {
        // AlamoFire requests
        let user = "admin"
        let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print(base64Credentials)
        
        /**
        // Get a list of all recipients
        Alamofire.request(.GET, "https://mobile-backend.givedirectly.org/api/v1/recipients/", headers: headers)
        .responseJSON { response in
        let json = response.result.value as! NSDictionary
        print (json)
        }
        **/
        
        // Query for a specific recipient
        Alamofire.request(.GET, "https://mobile-backend.givedirectly.org/api/v1/recipients/gd-10017093", headers: headers)
            .responseJSON { response in
            if let value: AnyObject = response.result.value {
                let json = JSON(value)
                print(json)
                if let recipientName = json["recipient"]["firstName"].string {
                    print(recipientName)
                }
                if let spendingPlans = json["recipient"]["spendingPlans"].string {
                    print(spendingPlans)
                }
                if let phase = json["recipient"]["phase"].string {
                    print(phase)
                }
            }
        }
        
        // Parse API call to return target recipient
        let query:PFQuery = PFQuery(className: "Recipients")
        query.orderByAscending("createdAt")
        
        // query.limit = 20 (default = 100)
        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
            recipientBrowserData = result!
            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
    }
}
