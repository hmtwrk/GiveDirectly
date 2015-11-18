//
//  Extensions.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 11/18/15.
//  Copyright © 2015 GiveDirectly. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func makeRound() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.clearColor().CGColor
//        layer.backgroundColor = UIColor.clearColor().CGColor
    }
}