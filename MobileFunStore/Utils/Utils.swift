//
//  Utils.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 08/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static let insetSize : Double = 8.0
    
    enum collection : String {
        case group = "Groups"
        case product = "Products"
    }
    
    enum ImageScales : CGFloat {
        case min = 1.0
        case max = 2.0
    }
        
    static func getDefaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
}

