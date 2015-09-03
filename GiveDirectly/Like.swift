//
//  Like.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/3/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import Foundation
import UIKit

class LikedItem {
    var liked = false
    
    func toggleLiked() {
        liked = !liked
    }
    
    // TODO: make a Parse API call for creating or deleting a Liked object
    // TODO: make a Parse API call to check how many Users have liked the item
    // TODO: make a Parse API call to update the total number of likes an item has
}