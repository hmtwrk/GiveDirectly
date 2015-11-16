//
//  Like.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation

class Liked {
    
    // default state = not liked
    var liked = false
    
    // number of likes
    // var totalLkes = 0 

    func toggleLiked() {
        liked = !liked
    }
}