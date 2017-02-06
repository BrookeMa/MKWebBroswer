//
//  MKWebsite.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


class MKWebsite: CustomStringConvertible {
    
    
    // MARK: Variables
    var id: String!
    var urlString: String!
    var name: String!
    var introduction: String!
    var logo: String!
    var character: String!
    // 0 录入
    // 1 被推荐
    var status: String!
    
    
    // MARK: Computed Properties

    var url: URL? {
        guard urlString.isEmpty == false else { return nil }
        return URL(string: urlString)!
    }
    
    var logoImage: UIImage! {
        get {
            return UIImage(named: logo)
        }
    }
    
    var description: String {
        
        var description = ""
        
        description += "id:                 \(id)"
        description += "urlString:          \(urlString)\n"
        description += "name:               \(name)\n"
        description += "introduction:       \(introduction)\n"
        description += "logo:               \(logo)\n"
        description += "character:          \(character)\n"
        description += "status:             \(status)\n"
        
        return description
    }
    
    
    init(dictionary: NSDictionary) {
        
        id              = dictionary["id"] as! String
        urlString       = dictionary["url"] as! String
        name            = dictionary["name"] as! String
        introduction    = ""
        logo            = dictionary["logo"] as! String
        character       = dictionary["character"] as! String
        status          = dictionary["status"] as! String
    }
    
    init(entity: MKWebsiteEntity) {
        
        id              = entity.id
        urlString       = entity.urlString
        name            = entity.name
        introduction    = entity.introduction
        logo            = entity.logo
        character       = entity.character
        status          = entity.status
    }
    
    class func websites(_ array: NSArray) -> [MKWebsite] {
        return array.map {
            MKWebsite(dictionary: $0 as! NSDictionary)
        }
    }
    
    class func websitesWithEntities(_ entities: [MKWebsiteEntity]) -> [MKWebsite] {
        return entities.map {
            MKWebsite(entity: $0)
        }
    }
}
