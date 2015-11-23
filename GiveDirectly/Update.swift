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
    
    // properties list
    var profileImageURL: String = ""
    var recipientDisplayName: String = ""
    var updateTitle: String = ""
    var date: String = ""
    var text: String = ""
    var userHasLikedUpdate: Bool = false
    var numberOfLikes: Int = 0
    var numberOfComments: Int = 0
    var isFlagged: Bool = false
    
    var relatedRecipient: Recipient = Recipient()
    
    var avatarImage: UIImage?
    
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

}