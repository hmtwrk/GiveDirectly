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
        query?.whereKey("isLive", equalTo: true)
        query?.includeKey("recipientAuthor")
        query?.orderByDescending(ParseUpdateCreatedAt)
        //        query?.limit = 20
        query?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func relatedUpdatesForRecipient(recipient: String, completionBlock: PFArrayResultBlock) {
        let query = Update.query()
        query?.whereKey("isLive", equalTo: true)
        query?.whereKey("GDID", equalTo: recipient)
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // make this return a completion block that sets the cell's data from cellForRowAtIndexPath?
    static func recipientImagesForCell(cell: UpdateTableViewCell, withRecipientData recipientData: PFObject?, orUpdateData: AnyObject) {
        // use the includeKey data to grab images, but if nil, use alternate method instead (matching GDID)
        // make recipientData an optional type
        
        if let recipientData = recipientData {
            
            // safely pull images without a crash
            if let recipientProfilePhoto = recipientData["image"] as? PFFile {
                recipientProfilePhoto.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data: imageData!)
                        cell.authorImageView.image = image
                        cell.authorImageView.layer.cornerRadius = cell.authorImageView.frame.size.width / 2
                        cell.authorImageView.clipsToBounds = true
                    } else {
                        // there was an error
                        print("There was an error of \(error).")
                    }
                }
                
            } else {
                
                // should be working, but not?
                // TODO: figure out why not
                cell.authorImageView.backgroundColor = UIColor.blackColor()
                cell.authorImageView.image = UIImage(named: "smallBlankProfileImage.pdf")
                cell.authorImageView.layer.cornerRadius = cell.authorImageView.frame.size.width / 2
                cell.authorImageView.clipsToBounds = true
                print("Update item does not have a profile photo.")
            }
            
        } else {
            
            // this data goes to a different function entirely
            
            // pointer doesn't exist, so use the older method by matching GDIDs
            // configure outlets with Parse data
//            let author:String! = (orUpdateData as AnyObject)["GDID"] as! String
//            
//            // check Recipients class to mine information
//            let query = PFQuery(className:"Recipients")
//            query.whereKey("gdid", equalTo: author)
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                if error == nil {
//                    
//                    // check to see if something exists
//                    if let objects = objects as? [PFObject] {
//                        for object in objects {
//                            
//                            // if name is pulled
//                            if let recipientName = object["firstName"] as? String {
//                                cell.authorNameLabel.text = recipientName
//                            }
//                            // if image is pulled
//                            if let recipientProfilePhoto = object["image"] as? PFFile {
//                                recipientProfilePhoto.getDataInBackgroundWithBlock {
//                                    (imageData: NSData?, error: NSError?) -> Void in
//                                    if (error == nil) {
//                                        let image = UIImage(data: imageData!)
//                                        cell.authorImageView.image = image
//                                        cell.authorImageView.layer.cornerRadius = cell.authorImageView.frame.size.width / 2
//                                        cell.authorImageView.clipsToBounds = true
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                } else {
//                    // log details of the failure
//                    print("There was an error \(error).")
//                }
//            }
//            
        }
        
    }
    
    // MARK: Fail-safe method
    static func failsafeUpdateWithRecipient(recipient: AnyObject) {
        print("\(recipient.objectId)! doesn't have an author field.")
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
    
    static func unlikeUpdate(user: PFUser, update: Update) {
        // 1
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToUpdate, equalTo: update)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            // how to handle error?
            if let error = error {
                print(error)
            }
            
            if let results = results as? [PFObject] {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    static func fetchLikesForUpdate(update: Update, completionBlock: PFArrayResultBlock) {
        
//        let currentUserLikes = PFQuery(className: ParseLikeClass)
//        currentUserLikes.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToUpdate, equalTo: update)
        query.includeKey(ParseLikeFromUser)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}