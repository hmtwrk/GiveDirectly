//
//  Like.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation

class Like {
    
    // not sure if this class is still necessary...
    
    // default state = not liked
    var liked = false


    func toggleLiked() {
        liked = !liked
    }
}