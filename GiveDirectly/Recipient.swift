//
//  Recipients.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class Recipient {
    
    class func getRecipients() -> [Recipient] {
        
        var recipientData = [Recipient]()
        
        if let URL = NSBundle.mainBundle().URLForResource("Recipients", withExtension: "plist") {
            if let recipientsFromPlist = NSArray(contentsOfURL: URL) {
                for dictionary in recipientsFromPlist {
                    let recipient = Recipient(dictionary: dictionary as! NSDictionary)
                    recipientData.append(recipient)
                }
            }
        }
        
//         Parse API call to return target recipient
//        let query:PFQuery = PFQuery(className: "RecipientUpdates")
//        query.orderByAscending("createdAt")
//        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
//            let recipientData = result!
        
        return recipientData
    }
    
//    var recipientName: String
//    var timeStamp: String
//    var recipientStory: String
//    var recipientImage: UIImage
//    var paymentPhaseImage: UIImage
    
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
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let caption = dictionary["Caption"] as? String
        let comment = dictionary["Comment"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }
    
    func queryParseForRecipients() {
            //
    }
    
    func heightForStory(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
