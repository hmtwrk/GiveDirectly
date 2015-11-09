//
//  RequestRouter.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 11/6/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import Foundation
import Alamofire

//enum Router: URLRequestConvertible {
//    
//    static let baseURLString = "https://mobile-backend.givedirectly.org/api/v1"
//    static let consumerKey = "" // no consumer key yet?
    
    // endpoints
    // 1) request list of recipient newsfeed items (Newsfeed view)
    // 2) request list of recipients (Recipients view)
    // 3) request user for profile (Accounts view)
    
    // every request needs to send the encoded credentials
    
//    case Newsfeed // no parameters at this time
//    case Recipients
//    case User
//    case Comments(Int, Int)
//    case Likes
    
//    var URLRequest: NSURLRequest {
//        let (path: String, parameters: [String: AnyObject]) = {
//            switch self {
//            case .Newsfeed:
//                let params = [
//            }
//        }
    
//    let URL = NSURL(string: Router.baseURLString)
//    let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
//    let encoding = Alamofire.ParameterEncoding.URL
//    
//    return encoding.encode(URLRequest, parameters: parameters).0
//    }

//}