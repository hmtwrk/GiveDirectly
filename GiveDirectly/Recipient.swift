//
//  Recipients.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class Recipient {
    
//    class func getRecipients() -> [Recipient] {
//        
//        var recipientData = [Recipient]()
//        
//        if let URL = NSBundle.mainBundle().URLForResource("Recipients", withExtension: "plist") {
//            if let recipientsFromPlist = NSArray(contentsOfURL: URL) {
//                for dictionary in recipientsFromPlist {
//                    let recipient = Recipient(dictionary: dictionary as! NSDictionary)
//                    recipientData.append(recipient)
//                }
//            }
//        }
//        
//        return recipientData
//    }
    
    //    var recipientName: String
    //    var timeStamp: String
    //    var recipientStory: String
    //    var recipientImage: UIImage
    //    var paymentPhaseImage: UIImage
    
    var recipientInfo: [AnyObject]
    var caption: String
    var comment: String
    var image: UIImage
    
    //    init(
    //        recipientName: String,
    //        timeStamp: String,
    //        recipientStory: String,
    //        recipientImage: UIImage,
    //        paymentPhaseImage: UIImage
    //        ) {
    //            self.recipientName = recipientName
    //            self.timeStamp = timeStamp
    //            self.recipientStory = recipientStory
    //            self.recipientImage = recipientImage
    //            self.paymentPhaseImage = paymentPhaseImage
    //    }
    
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
        
        //         Parse API call to return target recipient
        let query:PFQuery = PFQuery(className: "Recipients")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
            recipientBrowserData = result!
            NSNotificationCenter.defaultCenter().postNotificationName("refreshRecipientCollectionView", object: nil)
        }
    }
    
        func heightForStory(font: UIFont, width: CGFloat) -> CGFloat {
            let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            return ceil(rect.height)
        }
}
