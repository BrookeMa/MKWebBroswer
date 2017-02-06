//
//  MKCollectItem.swift
//  MK
//
//  Created by MK on 2016/10/25.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


enum CollectionType: String {
    case photo      = "0"
    case website    = "1"
}


class MKCollectItem: CustomStringConvertible {
    
    typealias CollectionType = String
    
    var id              : String!
    var title           : String?
    var imageData       : NSData?
    var headImageData   : NSData?
    var webURLString    : String!
    var imageURLString  : String?
    var type            : String!
    var offsetX         : Float?
    var offsetY         : Float?
    var timeInterval    : TimeInterval!
    
    
    // MARK: CustomStringConvertible
    
    var description: String {
        
        var description = ""
        
        description += "title:              \(title)\n"
        description += "type:               \(type)\n"
        description += "date:               \(date)\n"
        description += "webURLString:       \(webURLString)\n"
        description += "imageURLString:     \(imageURLString)\n"
        
        return description
    }
    
    
    // MARK: Computed Properties
    
    lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data as Data)
        }
        return nil
    }
    
    var date: String! {
        get {
            let date = Date(timeIntervalSince1970: timeInterval)
            
            return dateFormatter.string(from: date)
        }
    }
    
    init() {}
    
    init(entity: MKCollectionEntity) {
        
        id              = entity.id
        imageData       = entity.imageData
        title           = entity.title
        type            = entity.type
        webURLString    = entity.webURLString
        imageURLString  = entity.imageURLString
        offsetX         = entity.offsetX
        offsetY         = entity.offsetY
        timeInterval    = entity.timeInterval
        headImageData   = entity.headImageData
    }
    
    class func items(entities: [MKCollectionEntity]) -> [MKCollectItem] {
        return entities.map {
            return MKCollectItem(entity: $0)
        }
    }
}
