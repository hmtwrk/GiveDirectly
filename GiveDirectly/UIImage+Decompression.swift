//
//  UIImage+Decompression.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 8/14/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

extension UIImage {
    
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        drawAtPoint(CGPointZero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage
    }
    
}
