//
//  LabelModel.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 11/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import UIKit

struct LabelModel {
    
    var text : String
    private var expanded : Bool = false
    private var defaultLines : Int
    var isExpanded : Bool = false {
        didSet {
            expanded = isExpanded
            lines = (expanded == true) ? defaultLines : 0
        }
    }
    private var lines : Int!
    var getLines : Int {
        return lines
    }

    var font : UIFont
    var index : Int!
    var labelWidth : CGFloat
    
    init(text : String, font : UIFont, width : CGFloat = 0.0, defaultLines : Int = 1) {
        
        self.text = text
        self.font = font
        self.defaultLines = defaultLines
        self.lines = defaultLines
        self.labelWidth = width
    }
}
