//
//  DonateViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/11/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import WebKit

class DonateViewController: UIViewController {
    
    var webView: WKWebView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // switch variable to display donationTracker.pdf
        showDonationTracker = true

        
        // add the webView to the main View
        view.addSubview(webView)
        
        // disable auto-generated constraints, then define custom height and width constraints
        // the webView will have the same height and width as its superview's height and width
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        // load a default URL when the app starts
        let url = NSURL(string: "https://www.givedirectly.org/give-now.php")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)

    }
    
    // initialize the web view with frame of size zero
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
    
    // increment the user's donation amount by $1000
    override func viewDidAppear(animated: Bool) {
        
        // create a badge on the user profile tab item (after ten-second delay)
        delayBySeconds(10) {
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabArray.objectAtIndex(2) as! UITabBarItem
            tabItem.badgeValue = " "
        }
        
        
        let userID = PFUser.currentUser()?.objectId
        let query = PFQuery(className: "_User")
        query.getObjectInBackgroundWithId(userID!) {
            (donations: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let donations = donations {
                donations.incrementKey("donations", byAmount: 1000)
                donations.incrementKey("funded", byAmount: 1)
                donations.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // the donations key has been incremented
                        println("Looks like it worked.")
                    } else {
                        // there was a problem
                        println("Looks like there was a problem.")
                    }
                }
            }
        }
        
        

        }


}
