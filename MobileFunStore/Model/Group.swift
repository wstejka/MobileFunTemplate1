//
//  Group.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 19/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct Group {

    // MARK: - mandatory fields
    var title : String
    var description : String?
    var url: String
    var gs_link : String?
    var id : Int

    // MARK: - optional fields

}

extension Group : DocumentSerializable {

    init?(dictionary: [String : Any]) {

        guard let title = dictionary["title"] as? String,
            let id = dictionary["id"] as? Int,
            let url = dictionary["url"] as? String else {

                log.error("Lack of mandatory value(s): \(dictionary)")
                return nil
        }
        var cDescription : String?
        if let description = dictionary["description"] as? String {
            cDescription = description
        }
        var cGsLink : String?
        if let gs_link = dictionary["gs_link"] as? String {
            cGsLink = gs_link
        }

        self.init(title: title, description: cDescription, url: url, gs_link: cGsLink, id: id)
    }

    func dictionary() -> [String : Any] {
        
        return ["title" : title,
                "description" : description ?? "",
                "url" : url,
                "gs_link" : gs_link ?? "",
                "id" : id]
    }
}







