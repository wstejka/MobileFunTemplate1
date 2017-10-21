//
//  Product.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


struct Product {
    
    // MARK: - mandatory fields
    var name : String
    var price : Float
    var quantityInStock : Float
    var description : String
    
    // MARK: - optional fields
    var lastName : String = ""
    var producer : String = ""
    var discountPercent : Float = 0.0
//    var groups : [Group]
    
}

extension Product : DocumentSerializable {
    
    func dictionary() -> [String : Any] {
        
        return ["name" : name,
                "price" : price,
                "quantityInStock" : quantityInStock,
                "description" : description,
                "lastName" : lastName,
                "producer" : producer,
                "discountPercent" : discountPercent]
    }
    
    init?(dictionary: [String : Any]) {

        // Mandatory values
        guard let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? Float,
            let quantityInStock = dictionary["quantityInStock"] as? Float,
            let description = dictionary["description"] as? String else {
                log.error("Lack of mandatory value(s): \(dictionary)")
                return nil
        }
        
        // Optional values
        var cLastName : String = ""
        var cProducer : String = ""
        var cDiscountPercent : Float = 0.0
        if let lastName = dictionary["lastName"] as? String {
            cLastName = lastName
        }
        if let producer = dictionary["producer"] as? String {
            cProducer = producer
        }
        if let discountPercent = dictionary["discountPercent"] as? Float {
            cDiscountPercent = discountPercent
        }
        
        self.init(name: name, price: price, quantityInStock: quantityInStock, description: description,
                  lastName: cLastName, producer: cProducer, discountPercent: cDiscountPercent)
    }    
}
