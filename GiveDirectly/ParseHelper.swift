//
//  ParseHelper.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/8/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Parse


class ParseHelper {
    
    // Following Relation
    static let ParseFollowClass             = "Following"
    static let ParseFollowFromUser          = "fromUser"
    static let ParseFollowToUser            = "toUser"
    static let ParseFollowToRecipient       = "toRecipient"
    
    // Like Relation
    static let ParseLikeClass               = "Liked"
    static let ParseLikeToUpdate            = "likedRecipientUpdate"
    static let ParseLikeFromUser            = "fromUser"
    
    // Update Relation
    static let ParseUpdateRecipient         = "recipientAuthor"
    static let ParsePostCreatedAt           = "createdAt"
    
    // Flagged Content Relation
    static let ParseFlaggedContentClass     = "Flagged"
    static let ParseFlaggedContentFromUser  = "fromUser"
    static let ParseFlaggedContentToUpdate  = "toUpdate"
    static let ParseFlaggedContentToComment = "toComment"
    
    // User Relation
    static let ParseUserUsername            = "username"
    
    
    
    // 1 —— all Parse functions should be static, so that they can be called without
    // having to create an instance of ParseHelper
    
    
    // 2 —— in case following functionality is used in the future

    // this query will return all the Recipients objectIds the User follows
    static func followedUpdatesForCurrentUser(completionBlock: PFArrayResultBlock) {
        let followingQuery = PFQuery(className: "Following")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // this query will return all RecipientUpdates that are authored by
        // the followed Recipients
        let updatesFromFollowedRecipients = Update.query()
        updatesFromFollowedRecipients!.whereKey("recipientAuthor", matchesKey: "toRecipient", inQuery: followingQuery)
        updatesFromFollowedRecipients?.includeKey("recipientAuthor")
        updatesFromFollowedRecipients?.orderByDescending("createdAt")
        
        // 3 —— make the API call
        updatesFromFollowedRecipients?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func mostRecentUpdates(completionBlock: PFArrayResultBlock) {
        let query = Update.query()
        query?.orderByAscending("createdAt")
        query?.findObjectsInBackgroundWithBlock(completionBlock)
        // how to assign values to variables and reload tableView?
    }
    
    
}