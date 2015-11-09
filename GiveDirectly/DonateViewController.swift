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
        
        // add the webView to the main view
        view.addSubview(webView)
        
        // disable auto-generated constraints, then define custom height and width constraints
        // the webView will have the same height and width as its superview's height and width
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        // load a default URL when the app starts
        let url = NSURL(string: "https://www.givedirectly.org/give-now.php")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    // initialize the web view with frame of size zero
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
}
