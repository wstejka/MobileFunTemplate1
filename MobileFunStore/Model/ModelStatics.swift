//
//  ModelStatics.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import FirebaseFirestore

class Utils {

    enum FirestoreLink : String {
        
        case product = "product"
        case user = "user"
        case group = "group"
    }

    typealias CompletionType = ([DocumentChange]) -> Void

}

