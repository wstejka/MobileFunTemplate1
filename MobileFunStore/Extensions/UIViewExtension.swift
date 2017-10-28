//
//  UIViewExtension.swift
//  TestCollectionView
//
//  Created by Wojciech Stejka on 26/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension UIView  {
    
    // This method checks if given location (touched point) is in scope of UIView object
    func touched(in location: CGPoint) -> Bool {
        
        let frame = self.frame
        if location.x >= frame.minX &&
            location.x <= frame.maxX &&
            location.y >= frame.minY &&
            location.y <= frame.maxY {
            return true
        }
        return false
    }
}
