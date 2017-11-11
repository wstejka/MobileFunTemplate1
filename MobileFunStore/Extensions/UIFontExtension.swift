//
//  UIFontExtension.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 11/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    enum AvenirFonts : String {
        case mediumItalic = "AvenirNext-MediumItalic"
        case bold = "AvenirNext-Bold"
        case ultraLight = "AvenirNext-UltraLight"
        case demiBold = "AvenirNext-DemiBold"
        case heavyItalic = "AvenirNext-HeavyItalic"
        case heavy = "AvenirNext-Heavy"
        case medium = "AvenirNext-Medium"
        case italic = "AvenirNext-Italic"
        case ultraLightItalic = "AvenirNext-UltraLightItalic"
        case boldItalic = "AvenirNext-BoldItalic"
        case regular = "AvenirNext-Regular"
        case demiBoldItalic = "AvenirNext-DemiBoldItalic"
    }
    
    static func avenir(name: AvenirFonts, size : CGFloat) -> UIFont {
        return UIFont(name: name.rawValue, size: size)!
    }

}

