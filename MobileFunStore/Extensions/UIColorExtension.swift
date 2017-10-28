//
//  CGColorExtension.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 27/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var random : UIColor {
    
        get {
            return UIColor(red: .random(),
                           green: .random(),
                           blue: .random(),
                           alpha: 1.0)
        }
    }
}
