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
    
    // prepare variable for caching
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    // hope this works
    class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            Update.imageCache = NSCacheSwift<String, UIImage>()
        }
    }
    
    // properties list
    var profileImageURL: String = ""
    var recipientFirstName: String = ""
    var recipientLastName: String = ""
    var updateTitle: String = ""
    var date: String = ""
    var text: String = ""
    var userHasLikedUpdate: Bool = false
    var numberOfLikes: Int = 0
    var numberOfComments: Int = 0
    var isFlagged: Bool = false
    
    var relatedRecipient: Recipient = Recipient()
    
    var avatarImage: Observable<UIImage?> = Observable(nil)
    
    var type: String = ""
    var gdid: String = ""
    var fromGD: Bool = false
    var isPinned: Bool = false
    
    // handle commenting
    var commments = [Comment]()
    
    // control liked status
    func toggleLiked() {
        userHasLikedUpdate = !userHasLikedUpdate
    }
    
    // download image for recipient avatar
    // download associated image for cell (seems this has to go here)
    func downloadImage() {
        
        // 1
//        avatarImage.value = Update.imageCache[self.profileImageURL]
        
        // if image is not yet downloaded, retrieve it
        if (avatarImage.value == nil) {
            
            // 2
            GDService.downloadImage(profileImageURL) { data in
                
                if let data = data {
                    
                    let image = UIImage(data: data)
                    self.avatarImage.value = image
                }
            }
        }
    }
}

// static func downloadImage(imageURL: String, completionBlock: (NSData) -> () ) {
//
//Alamofire.request(.GET, imageURL, headers: headers).response() {
//    (_, _, data, _) in
//    
//    completionBlock(data!)
//}
//}
