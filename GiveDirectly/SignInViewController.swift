//
//  SignInViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 10/9/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        // NOTE: When users silently sign in, he Sign-In SDK automatically acquires access tokens and automatically refreshes them when necessary. If you need the access token and want the SDK to automatically handle refreshing it, you can use the getAccessTokenWithHandler: method.
        
        // To explicitly refresh the access token, call the refreshAccessTokenWithHandler: method.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }


}
