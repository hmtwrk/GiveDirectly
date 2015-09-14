
//  AppDelegate.swift
//  GiveDirectly
//
//  Created by hai tran on 6/10/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Override point for customization after application launch.
        //  UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // set security settings for Parse users (user can read all public objects, but can only modify objects he or she personally created)
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        // Change appearance of tab bar navigation globally
        let tabBarAppearance = UITabBar.appearance()
        let tabBarItemAppearance = UITabBarItem.appearance()
        let font = UIFont(name: "Helvetica Neue", size: 10)
        let attributes: [NSObject : AnyObject]? = [ NSFontAttributeName : font! ]
        tabBarAppearance.barTintColor = UIColor.whiteColor()
        tabBarAppearance.tintColor = UIColor(red: 72.0/255, green: 185.0/255, blue: 163.0/255, alpha: 1.0)
        tabBarAppearance.translucent = false
        tabBarItemAppearance.setTitleTextAttributes(attributes, forState: .Normal)
        
        // Change appearance of navigation bars globally
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.translucent = false
        navBarAppearance.barTintColor = UIColor.whiteColor()
        navBarAppearance.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        navBarAppearance.shadowImage = UIImage(named: "TransparentPixel")
        
        // register Parse subclass (necessary?)
//        Post.registerSubclass()
        
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse (these keys are for app "GiveDirectlyDataStructure"
        Parse.setApplicationId("Aze1UzP0FL1GRtT6E44T0ehscBQKyjl61vP0lO4I",
            clientKey: "hojda4HJ5PXLzH68R0l8Q6uCT2T38SxbRYbURVjK")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // log in a user
        self.easyLogin()
        
        // Check for user's login status
        self.checkUserStatus()
        self.refreshUserData()
        
        
        
        return true
    }
    
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkUserStatus() {
        
        var currentUser = PFUser.currentUser()
        let currentUserName: AnyObject? = currentUser?.objectForKey("fullName")
        if currentUser != nil {
            
            // do stuff with the user
            println("You are already logged in as \"\(currentUserName!).\"")
            
        } else {
            
            // show the signup or login screen
            let parseUsername = "braddourif"
            let testPassword = "testpass123"
            
            PFUser.logInWithUsernameInBackground(parseUsername, password: testPassword) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    
                    // do successful login stuff
                    println("You have successfully logged in as \"\(parseUsername).\"")
                } else {
                    // oh no
                    println("There was an error of \(error).")
                }
            }
        }
        
    }
    
    func easyLogin() {
        
        let parseUsername = "michaelfaye"
//        let parseUsername = "seanmoriarity"
        let testPassword = "testpass123"
        
        PFUser.logInWithUsernameInBackground(parseUsername, password: testPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                // do successful login stuff
                println("You have successfully logged in as \"\(parseUsername).\"")
            } else {
                // oh no
                println("There was an error of \(error).")
            }
        }
    }
    
    func refreshUserData() {
        
        // refresh user data
        var currentUser = PFUser.currentUser()
        currentUser?.fetchInBackgroundWithBlock { (object, error) -> Void in
            println("Refreshed!")
//            println(currentUser)
        }
        
    }
    
}

