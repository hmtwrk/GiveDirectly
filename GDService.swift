//
//  GDService.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 10/28/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import Alamofire

struct GDService {
    
    // TODO: implement filtering suffixes into cases?
    // will all cases be relevant (e.g. comment liking / replying)?
    
    private static let baseURL = "https://mobile-backend.givedirectly.org"
//    private static let clientID = ""
//    private static let clientSecret = ""
    
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
            case .Recipients: return "/api/vi/recipients/"
            case .Updates: return "/api/v1/updates/"
            case .UpdateId(let id): return "/api/vi/updates/\(id)"
            case .UpdateLike(let id): return "/api/vi/updates/\(id)/like"
            case .UpdateReply(let id): return "/api/vi/updates/\(id)/reply"
            case .CommentLike(let id): return "/api/vi/comments/\(id)/like"
            case .CommentReply(let id): return "/api/vi/updates/\(id)/reply"
            }
        }
    }
    
//    static func recipientsForCollection
    

}
