
//  AppDelegate.swift
//  GiveDirectly
//
//  Created by hai tran on 6/10/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Override point for customization after application launch.
        //  UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // Change appearance of tab bar navigation globally
        let tabBarAppearance = UITabBar.appearance()
//        let tabBarItemAppearance = UITabBarItem.appearance()
//        let font = UIFont(name: "Helvetica Neue", size: 10)
//        let attributes: [NSObject : AnyObject]? = [ NSFontAttributeName : font! ]
        tabBarAppearance.barTintColor = UIColor.whiteColor()
        tabBarAppearance.tintColor = UIColor(red: 72.0/255, green: 185.0/255, blue: 163.0/255, alpha: 1.0)
        tabBarAppearance.translucent = false
//        tabBarItemAppearance.setTitleTextAttributes(attributes, forState: .Normal)
        
        // Change appearance of navigation bars globally
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.translucent = false
        navBarAppearance.barTintColor = UIColor.whiteColor()
        navBarAppearance.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        navBarAppearance.shadowImage = UIImage(named: "TransparentPixel")
        
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
//        Parse.enableLocalDatastore()
        
        // Initialize Parse (these keys are for app "GiveDirectlyDataStructure"
//        Parse.setApplicationId("Aze1UzP0FL1GRtT6E44T0ehscBQKyjl61vP0lO4I",
//            clientKey: "hojda4HJ5PXLzH68R0l8Q6uCT2T38SxbRYbURVjK")
        
        // [Optional] Track statistics around application opens.
//        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Configure Google Sign-in
        GIDSignIn.sharedInstance().clientID = "568617369900-o0t0a9jmjmtt07i1ueaic5moe5lnuv34.apps.googleusercontent.com"
        
        
        // initialize Google sign-in
        // "No registered handler for URL scheme" errors refer to other apps that may be installed on the device
//        var configureError: NSError?
        
        // the following line is only necessary when using Cocoapods?
        // the values are handled directly through GIDSignIn just above
//        GGLContext.sharedInstance().configureWithError(&configureError)
        
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        // download all 
        // download recipients object
        
        // download first ten updates

        return true
    }
    
    // MARK: app life-cycle functions
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // TODO: update the newsfeed interface with fresh API calls (only newsfeed? maybe both recipient / newsfeed for now)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MARK: GiveDirectly sign-in
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        GDBackendAPIManager.sharedInstance.processOAuthStep1Response(url)
        return true
    }
    
    // MARK: Google sign-in
    
    // For Google sign-in to work, GiveDirectly > Targets > GiveDirectly > Build Settings
    // > Other Linker Flags must be set to -force_load GoogleSignIn.framework/GoogleSignIn
    // (setting that field to -ObjC will break Parse-related functionality)
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                    // for client-side use only!
            let idToken = user.authentication.idToken   // safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            
            // "ToggleAuthUINotification" is the aName, of type String
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user: \(name)"])
            
            print(userId)
            print(idToken)
            print(name)
            print(email)
            
        } else {
            print("\(error.localizedDescription)")
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification", object: nil, userInfo: nil)
        }
    }
    
    
    // IMPORTANT: if you need to pass the currently signed-in user to a backend server, send the user's ID token to your backend server and validate the token on the server.
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        // perform any operations when the user disconnects from app here
        NSNotificationCenter.defaultCenter().postNotificationName("ToggleAuthUINotification", object: nil, userInfo: ["statusText": "User has disconnected."])
        
    }
    
    // MARK: Alamofire user login
    // AlamoFire requests

    
}

