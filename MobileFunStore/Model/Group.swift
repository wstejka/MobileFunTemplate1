//
//  Group.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 19/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct Group {

    // MARK: - mandatory fields
    var name : String?
    var description : String
    var url: String
    var gs_link : String?
    var id : Int

    // MARK: - optional fields

}

extension Group : DocumentSerializable {

    init?(dictionary: [String : Any]) {

        guard let description = dictionary["description"] as? String,
            let id = dictionary["id"] as? Int,
            let url = dictionary["url"] as? String else {

                log.error("Lack of mandatory value(s): \(dictionary)")
                return nil
        }
        var cName : String?
        if let name = dictionary["name"] as? String {
            cName = name
        }
        var cGsLink : String?
        if let gs_link = dictionary["gs_link"] as? String {
            cGsLink = gs_link
        }

        self.init(name: cName, description: description, url: url, gs_link: cGsLink, id: id)
    }

    func dictionary() -> [String : Any] {
        
        return ["name" : name ?? "",
                "description" : description,
                "url" : url,
                "gs_link" : gs_link ?? "",
                "id" : id]
    }
}







