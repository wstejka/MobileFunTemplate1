//
//  ModelStatics.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import FirebaseFirestore

class Utils {

    typealias CompletionType = ([DocumentChange]) -> Void
    static let insetSize : Double = 8.0
    
    enum collection : String {
        case group = "Groups"
        case product = "Products"
    }
}

