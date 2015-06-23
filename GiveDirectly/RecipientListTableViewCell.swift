//
//  RecipientListTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 6/12/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit
import Parse
import Bolts

//protocol RecipientListTableViewCellDelegate : class {
//    
//}


class RecipientListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberChildrenLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
//    weak var delegate: RecipientListTableViewCellDelegate?
    
    
//    func configureWithParse() {
//        
//        var biodataQuery:PFQuery = PFQuery(className: "Registration")
//        biodataQuery.whereKey("gdid", equalTo: "KE2014tester")
//        biodataQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
//            
//            for recipientBiodata in objects! {
//                let recipientName:String? = (recipientBiodata as! PFObject)["name"] as? String
//                let recipientAge:Int! = (recipientBiodata as! PFObject)["age"] as? Int
//                let recipientOccupation:String? = (recipientBiodata as! PFObject)["job"] as? String
//                let recipientLocation:String? = (recipientBiodata as! PFObject)["location"] as? String
//                let recipientNumberChildren:Int! = (recipientBiodata as! PFObject)["children"] as? Int
//                
//                self.nameLabel.text = recipientName
//                self.ageLabel.text = String(stringInterpolationSegment: recipientAge)
//                self.occupationLabel.text = recipientOccupation
//                self.locationLabel.text = recipientLocation
//                self.numberChildrenLabel.text = String(stringInterpolationSegment: recipientNumberChildren)
//                
//                println(recipientNumberChildren)
//            }
//        }
//        
//        var query:PFQuery = PFQuery(className: "Followup")
//        query.whereKey("GDID", equalTo: "KE2014032075")
//        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
//            
//            for recipientData in objects! {
//                let recipientDescription:String? = (recipientData as! PFObject)["dayToDayDifference"] as? String
//                
//                self.descriptionLabel.text = recipientDescription
//
//                
//            }
//        }
//    }
}