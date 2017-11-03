//
//  Product.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import Firebase

struct Product {
    
    // MARK: - mandatory fields
    var title : String
    var shortDescription : String
    var longDescription : String
    var id : String
    var parent_id : String
    var parent_ref : DocumentReference
    var order : Int
    var quantityInStock : Float
    var price : Float

    // Optionals
    var images : [String] = []
    var urls : [String] = []

}

extension Product : DocumentSerializable {
    
    init?(dictionary: [String : Any]) {

        // Mandatory values
        guard let title = dictionary["title"] as? String,
            let shortDescription = dictionary["shortDescription"] as? String,
            let longDescription = dictionary["longDescription"] as? String,
            let id = dictionary["id"] as? String,
            let parent_id = dictionary["parent_id"] as? String,
            let parent_ref = dictionary["parent_ref"] as? DocumentReference,
            let order = dictionary["order"] as? Int,
            let price = dictionary["price"] as? Float,
            let quantityInStock = dictionary["quantityInStock"] as? Float
        else {
                log.error("Lack of mandatory value(s): \(dictionary)")
                return nil
        }
        
        // Optional values
        var cImages : [String] = []
        if let images = dictionary["images"] as? [String] {
            cImages = images
        }
        var cUrls : [String] = []
        if let urls = dictionary["urls"] as? [String] {
            cUrls = urls
        }

        self.init(title: title, shortDescription: shortDescription, longDescription: longDescription, id: id,
                  parent_id: parent_id, parent_ref: parent_ref, order: order, quantityInStock: quantityInStock,
                  price: price, images: cImages, urls: cUrls)
    }
    
    func dictionary() -> [String : Any] {
        
        return ["title" : title,
                "shortDescription" : shortDescription,
                "longDescription" : longDescription,
                "id" : id,
                "parent_id" : parent_id,
                "parent_ref" : parent_ref,
                "order" : order,
                "price" : price,
                "quantityInStock" : quantityInStock,
                "images" : images,
                "urls" : urls]
    }
    

}
