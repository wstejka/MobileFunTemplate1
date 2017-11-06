//
//  ModelStatics.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import FirebaseFirestore
import UIKit

class Utils {

    typealias CompletionType = ([DocumentChange]) -> Void
    static let insetSize : Double = 8.0
    
    enum collection : String {
        case group = "Groups"
        case product = "Products"
    }
    
    enum ImageScales : CGFloat {
        case min = 1.0
        case max = 2.0
    }
}

