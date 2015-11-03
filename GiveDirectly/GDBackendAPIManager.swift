//
//  APIManager.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 10/29/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit

class GDBackendAPIManager {

    static let sharedInstance = GDBackendAPIManager()
    
    // the following two variables shouldn't be stored within the app,
    // as they can be extracted by a malicious user...
    var clientID: String = "1234567890"
    var clientSecret: String = "abcdefghijkl"
    
    
    // handlers for the OAuth process...
    // stored as vars since sometimes authorization requires a round trip to Safari that
    // makes it difficult to just keep a reference to it
    var OAuthTokenCompletionHandler:(NSError? -> Void)?
    
    func hasOAuthToken() -> Bool {

        // TODO: implement
        return false
    }
    
    // MARK: OAuth flow
    
    // sample flow for GitHub access:
    // 1) redirect users to GitHub to request access
    // 2) GitHub redirects back to app with a code
    // 3) exchange the code for an access token
    // 4) use the access token to access the API
    
    // TODO: what is the GD backend's URL for OAuth?
    // example (for GitHub): https://github.com/login/oauth/authorize
    
    
    
    func startOAuth2Login() {
        
//        let authPath: String = "mobile-backend.givedirectly.org/oauth/authorize?client_id=\(clientID)"
//        if let authURL: NSURL = NSURL(string: authPath) {
        
//            UIApplication.sharedApplication().openURL(authURL)
//        }
        
        // TODO: implement
        // TODO: call completionHandler after getting token or error
    }
    
    func processOAuthStep1Response(url: NSURL) {
        // TODO: implement
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        var code: String?
        
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercaseString == "code") {
                    code = queryItem.value
                    break
                }
            }
        }
    }
}
