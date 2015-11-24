//
//  GDService.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 10/28/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Alamofire

struct GDService {
    
    // TODO: implement filtering suffixes into cases?
    // will all cases be relevant (e.g. comment liking / replying)?
    
    private static let baseURL = "https://mobile-backend.givedirectly.org"
    //    private static let clientID = ""
    //    private static let clientSecret = ""
    
    private static let user = "admin"
    private static let password = "8PLXLNuyyS6g2AsCAZNiyjF7"
    private static let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    private static let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    private static let headers = ["Authorization": "Basic \(base64Credentials)"]
    private static let userID = "SUPERADMINISTRATOR"
    
    private static let workingURL = "https://mobile-backend.givedirectly.org/api/v1/users/SUPERADMINISTRATOR"
    private static let testURL = "https://mobile-backend.givedirectly.org/api/v1/recipients/users/SUPERADMINISTRATOR"

    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Signup
        case Recipients
        case Updates
        case UpdateId(udpateId: Int)
        case UpdateLike(updateId: Int)
        case UpdateReply(updateId: Int)
        case CommentLike(commentId: Int)
        case CommentReply(commentId: Int)
        
        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Signup: return "/api/v1/signup"
            case .Recipients: return "/api/v1/recipients/users"
            case .Updates: return "/api/v1/newsfeeds/users"
            case .UpdateId(let id): return "/api/v1/updates/\(id)"
            case .UpdateLike(let id): return "/api/v1/updates/\(id)/like"
            case .UpdateReply(let id): return "/api/v1/updates/\(id)/reply"
            case .CommentLike(let id): return "/api/v1/comments/\(id)/like"
            case .CommentReply(let id): return "/api/v1/updates/\(id)/reply"
            }
        }
    }
    
    static func updatesForNewsfeed(completionBlock: (NSDictionary?, NSError?) -> () ) {
        let limit = 10
        let filter = "?limit=" + String(limit)
        let URLString = baseURL + ResourcePath.Updates.description + "/" + userID + filter
        //        let parameters = [
        //            "page": String(page)
        //            "client_id": clientID
        //        ]
        
        print("This is the URL string I'm sending: \(URLString).")
        
        Alamofire.request(.GET, URLString, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
    
    static func updatesForNewsfeedScrolling(offset: Int, completionBlock: (NSDictionary?, NSError?) -> () ) {
        let limit = 10
        let filter = "?offset=" + String(offset) + "&limit=" + String(limit)
        let URLString = baseURL + ResourcePath.Updates.description + "/" + userID + filter
        //        let parameters = [
        //            "page": String(page)
        //            "client_id": clientID
        //        ]
        
        print(offset)
        print(URLString)
        
        Alamofire.request(.GET, URLString, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }


    
    static func profilesForRecipients(completionBlock: (NSDictionary?, NSError?) -> () ) {
        let limit = ""
        let filter = "" + String(limit)
        let URLString = baseURL + ResourcePath.Recipients.description + "/" + userID + filter
        //        let parameters = [
        //            "page": String(page)
        //            "client_id": clientID
        //        ]
        
        print(URLString)

        Alamofire.request(.GET, URLString, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
    
    static func profilesForRecipientsView(completionBlock: (NSDictionary?, NSError?) -> () ) {
        let limit = 12
        let filter = "?limit=" + String(limit)
        let URLString = baseURL + ResourcePath.Recipients.description + "/" + userID + filter
        //        let parameters = [
        //            "page": String(page)
        //            "client_id": clientID
        //        ]
        
        print(URLString)
        
        Alamofire.request(.GET, URLString, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
    
    static func profilesForRecipientsViewScrolling(offset: Int, completionBlock: (NSDictionary?, NSError?) -> () ) {
        let limit = 12
        let filter = "?offset=" + String(offset) + "&limit=" + String(limit)
        let URLString = baseURL + ResourcePath.Recipients.description + "/" + userID + filter
        //        let parameters = [
        //            "page": String(page)
        //            "client_id": clientID
        //        ]
        
        print(URLString)
        
        Alamofire.request(.GET, URLString, headers: headers)
            .responseJSON { response in
                completionBlock(response.result.value as? NSDictionary, response.result.error)
        }
    }
    
    
    
    static func downloadImage(imageURL: String, completionBlock: (NSData?) -> () ) {
        
        Alamofire.request(.GET, imageURL, headers: headers).response() {
            (_, _, data, _) in
            
            completionBlock(data)
        }
    }
    
    static func likeUpdateWithID(updateID: Int, token: String, response: (successful: Bool) -> () ) {
        let urlString = baseURL + ResourcePath.UpdateLike(updateId: updateID).description
        likeWithURLString(urlString, token: token, response: response)
    }
    
    private static func likeWithURLString(urlString: String, token: String, response: (successful: Bool) -> () ) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    }
    
//    static func recipientsForCollection
}
