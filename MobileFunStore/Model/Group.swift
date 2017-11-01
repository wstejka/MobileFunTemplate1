//
//  Group.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 19/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import FirebaseFirestore

struct Group {

    // MARK: - mandatory fields
    var title : String
    var shortDescription : String
    var longDescription : String
    var imageName: String
    var level : Int
    var gs_link : String?
    var order : Int
    var parent_id : String?
    var parent_ref : DocumentReference?
    // This is workaround as for now there is no possible to check if document has a collection
    var final : Bool
    
    var id : String
    var url: String

}

extension Group : DocumentSerializable {

    init?(dictionary: [String : Any]) {

        guard let title = dictionary["title"] as? String,
            let order = dictionary["order"] as? Int,
            let level = dictionary["level"] as? Int,
            let imageName = dictionary["imageName"] as? String,
            let final = dictionary["final"] as? Bool,
            let id = dictionary["id"] as? String,
            let shortDescription = dictionary["shortDescription"] as? String,
            let longDescription = dictionary["longDescription"] as? String,
            let url = dictionary["url"] as? String
            else {

                log.error("Lack of mandatory value(s): \(dictionary)")
                return nil
        }

        var cGsLink : String?
        if let gs_link = dictionary["gs_link"] as? String {
            cGsLink = gs_link
        }
        var cParentId : String?
        if let parent_id = dictionary["parent_id"] as? String {
            cParentId = parent_id
        }
        var cParentRef : DocumentReference?
        if let parent_ref = dictionary["parent_ref"] as? DocumentReference {
            cParentRef = parent_ref
        }

        self.init(title: title, shortDescription: shortDescription, longDescription: longDescription, imageName: imageName, level: level, gs_link: cGsLink, order: order, parent_id: cParentId, parent_ref: cParentRef, final: final, id: id, url: url)
    }

    func dictionary() -> [String : Any] {
        
        return ["title" : title,
                "shortDescription" : shortDescription,
                "longDescription" : longDescription,
                "imageName" : imageName,
                "level" : level,
                "gs_link" : gs_link ?? "",
                "order" : order,
                "final" : final,
                "id" : id,
                "url" : url]
    }
}







