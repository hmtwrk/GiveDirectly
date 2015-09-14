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
    static let ParseUpdateCreatedAt         = "createdAt"
    
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
    
    // MARK: Newsfeed
    
    static func mostRecentUpdates(completionBlock: PFArrayResultBlock) {
        let query = Update.query()
        query?.orderByDescending(ParseUpdateCreatedAt)
//        query?.limit = 20
        query?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: Following
    
    static func followedUpdatesForCurrentUser(completionBlock: PFArrayResultBlock) {
        let followingQuery = PFQuery(className: ParseFollowClass)
        followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
        
        // this query will return all RecipientUpdates that are authored by
        // the followed Recipients
        let updatesFromFollowedRecipients = Update.query()
        updatesFromFollowedRecipients!.whereKey(ParseUpdateRecipient, matchesKey: ParseFollowToRecipient, inQuery: followingQuery)
        updatesFromFollowedRecipients?.includeKey(ParseUpdateRecipient)
        updatesFromFollowedRecipients?.orderByDescending(ParseUpdateCreatedAt)
        
        updatesFromFollowedRecipients?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    

    
    // MARK: Likes
    
    static func likeUpdate(user: PFUser, update: Update) {
        let likeObject = PFObject(className: ParseLikeClass)
        likeObject[ParseLikeFromUser] = user
        likeObject[ParseLikeToUpdate] = update
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, update: Update) {
        // 1
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToUpdate, equalTo: update)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            // how to handle error?
            if let error = error {
                println(error)
            }
            
            if let results = results as? [PFObject] {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    static func likesForUpdate(update: Update, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToUpdate, equalTo: update)
        
        // 2
        query.includeKey(ParseLikeFromUser)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}