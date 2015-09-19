//
//  CommentTableViewCell.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class UpdateFooterTableViewCell: UITableViewCell {
    

    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
    
    
    

    func configureFooterTableViewCell() {
        
        // the username would be pulled from Parse
        var authorName = "Lloyd W"
        authorName += " "
        
        let commentNumber:Int? = 33
        
        
        // 1
        let commentText = "Everything is going great." as NSString
        let attributedComment = NSMutableAttributedString(string: commentText as String)
        
        
        // add attributes for the commenting author's name
        let userCommentAuthorAttributes = [
            NSForegroundColorAttributeName: UIColor.orangeColor(),
//            NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!
//            NSFontAttributeName: UIFont(name: "HelveticaNeueBold", size: 12)
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12)
        ]
        
        // add attributes for a comment from a GiveDirectly representative
        _ = [
            NSForegroundColorAttributeName: UIColor.greenColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12)
        ]
        
        
        let attributedAuthorName = NSMutableAttributedString(string: authorName, attributes: userCommentAuthorAttributes)
//        attributedAuthorName.
        
        if commentNumber != nil {
            self.numberOfCommentsLabel.text = String(stringInterpolationSegment: commentNumber!)
        }
        
        attributedAuthorName.appendAttributedString(attributedComment)
        self.userCommentLabel.attributedText = attributedAuthorName
        
    }

}
