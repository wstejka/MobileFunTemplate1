//
//  LabelViewModel.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 11/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import UIKit

struct LabelViewModel {
    
    var text : String
    private var expanded : Bool = false
    private var maxLines : Int
    var isExpanded : Bool = false {
        didSet {
            expanded = isExpanded
            lines = (expanded == true) ? 0 : maxLines
        }
    }
    private var lines : Int = 2
    var getLines : Int {
        return lines
    }

    var font : UIFont
    var index : Int!

    var top : CGFloat
    var leading : CGFloat
    var trailing : CGFloat
    var bottom : CGFloat
    
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {

        let width = tableSize.width - (leading + trailing)
        let labelHeight = text.height(constraintedWidth: width, font: font, numberOfLines: lines)
        let cellHeight = labelHeight + (top + bottom)

        return cellHeight
    }
    
    init(text : String, font : UIFont, maxLines : Int = 2,
         top : CGFloat = 0.0,
         leading : CGFloat = 0.0,
         trailing : CGFloat = 0.0,
         bottom : CGFloat = 0.0) {
        
        self.text = text
        self.font = font
        self.maxLines = maxLines
        self.top = top
        self.leading = leading
        self.trailing = trailing
        self.bottom = bottom
    }
}
