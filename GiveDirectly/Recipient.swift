//
//  Recipients.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

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
