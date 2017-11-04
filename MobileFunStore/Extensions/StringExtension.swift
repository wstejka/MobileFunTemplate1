//
//  String+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/03/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func localized(withDefaultValue:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: withDefaultValue, comment: "")
    }

    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "test", comment: withComment)
    }

    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}

extension String {
    
    func throwException(_ code : Int = 1) -> NSError {
        
        let userInfo = ["error" : self]
        let domain = String(#function) + ":" + String(#line)
        return NSError(domain: domain, code: code, userInfo: userInfo);
    }

}

extension String {

    var length : Int{
        return self.count //characters.count
    }
    // string[] -> 'character'
    subscript (i: Int) -> String? {
        
        return ((i < self.length) ? self[Range(i ..< i + 1)] : nil)
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
}


extension String {
    
    func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// Update for Swift 3 (Xcode 8):
// https://gist.github.com/robnadin/2720534f91702c444b6b9bde0fdfe224
// Cast Range<String.Index> to NSRange
extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

extension String {
    
    func height(constraintedWidth width: CGFloat, font: UIFont, numberOfLines : Int = 0) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
