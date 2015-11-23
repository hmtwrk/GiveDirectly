//
//  Recipients.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/13/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Alamofire

class Recipient {
    
    // property list
    var gdid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var displayName: String = ""
    var recipientViewAnnotation: String = ""
    var age: Int = 0
    var gender: String = ""
    var maritalStatus: String = ""
    var numberOfChildren: Int = 0
    var village: String = ""
    var paymentPhase: String = ""
    var spendingPlans: String = ""
    var achievements: String = ""
    var goals: String = ""
    var challenges: String = ""
    
    var avatarURL: String = ""
    var actionURL: String = ""

    var avatarImage: UIImage?
    var actionImage: UIImage?
    
}