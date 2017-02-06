//
//  MKCollectionEntity+Extension.swift
//  MK
//
//  Created by MK on 2016/11/14.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


extension MKCollectionEntity {
    
    func set(collectionItem: MKCollectItem) {
        
        id              = collectionItem.id
        imageData       = collectionItem.imageData
        title           = collectionItem.title
        type            = collectionItem.type
        webURLString    = collectionItem.webURLString
        imageURLString  = collectionItem.imageURLString
        offsetX         = collectionItem.offsetX ?? 0
        offsetY         = collectionItem.offsetY ?? 0
        timeInterval    = collectionItem.timeInterval
        headImageData   = collectionItem.headImageData
    }
}
