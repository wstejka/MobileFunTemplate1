//
//  CGFloatExtension.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 27/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
