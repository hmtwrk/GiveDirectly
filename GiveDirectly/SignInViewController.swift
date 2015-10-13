//
//  SignInViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 10/9/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import UIKit

// have no idea what this line does "match the ObjC symbol name inside Main.storyboard"
// essentially, the name in parenthesis must match the VC class... ugh
//@objc(SignInViewController)

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.statusText.text = "Hang out with Google."
        
        // if a token is already stored on the device, the user won't have to login again
        GIDSignIn.sharedInstance().signInSilently()
        
        // the colon after receiveToggleAuthUINotification is extremely important
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "receiveToggleAuthUINotification:",
            name: "ToggleAuthUINotification",
            object: nil)
        
        statusText.text = "Initialized app..."
        toggleAuthUI()
        
        // NOTE: When users silently sign in, he Sign-In SDK automatically acquires access tokens and automatically refreshes them when necessary. If you need the access token and want the SDK to automatically handle refreshing it, you can use the getAccessTokenWithHandler: method.
        
        // To explicitly refresh the access token, call the refreshAccessTokenWithHandler: method.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        
        statusText.text = "Signed out."
        toggleAuthUI()
    }
    
    @IBAction func didTapDisconnect(sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        statusText.text = "Disconnecting."
    }
    
    
    
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            // signed in
            signInButton.hidden = true
            signOutButton.hidden = false
            disconnectButton.hidden = false
        } else {
            signInButton.hidden = false
            signOutButton.hidden = true
            disconnectButton.hidden = true
            statusText.text = "Sign in with Google."
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ToggleAuthUINotification", object: nil)
    }
    
    // what is this @objc thing?
//    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
    func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                let userInfo:Dictionary<String, String!> = notification.userInfo as! Dictionary<String, String!>
                self.statusText.text = userInfo["statusText"]
            }
        }
    }


}
