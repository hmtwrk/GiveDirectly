//
//  NSDate+Ago.swift
//  Created by Jesse Ziegler on 5/27/15.
//  Copyright (c) 2015 Jesse Ziegler. All rights reserved.
//
//  http://www.jesseziegler.com
//
//  http://github.com/jdziegler/SwiftAgo
//

import Foundation

/* Intervals represents in seconds */
let aminute = 60
let anhour = aminute*aminute
let aday = anhour*24
let aweek = aday*7
let amonth = aday*30 //30 Day Month
let ayear = aday*365


extension NSDate {
    
    var ago: String {
        
        let now : NSDate = NSDate()
        
        /* Convert from NSTimeInterval to Int */
        let interval = now.timeIntervalSinceDate( self )
        let nsnumber = NSNumber( double: interval )
        var seconds = Int( nsnumber )
        
        /* switch case */
        switch(seconds){
        case  let x where x < 5:
            
            return "just now"
            
        case let x where x < aminute:
            
            return "\(seconds) seconds ago"
            
        case let x where x < (2*aminute):
            
            return "a minute ago"
            
        case let x where x < anhour:
            
            return "\(seconds/aminute) minutes ago"
            
        case let x where x < 2*anhour:
            
            return "an hour ago"
            
        case let x where x < aday:
            
            return "\(seconds/anhour) hours ago"
            
        case let x where x < 2*aday:
            
            return "yesterday"
            
        case let x where x < aweek:
            
            return "\(seconds/aday) days ago"
            
        case let x where x < 2*aweek:
            
            return "last week"
            
        case let x where x < amonth:
            
            return "\(seconds/aweek) weeks ago"
            
        case let x where x < 2*amonth:
            
            return "last month"
            
        case let x where x < ayear:
            
            return "\(seconds/amonth) months ago"
            
        case let x where x < 2*ayear:
            
            return "last year"
            
        default:
            
            return "\(seconds/ayear) years ago"
        }
    }
}
