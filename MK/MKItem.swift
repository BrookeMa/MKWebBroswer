//
//  MKItem.swift
//  MK
//
//  Created by MK on 16/8/14.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


class MKItem: CustomStringConvertible {
    
    
    // MARK: Constants
    
    let imageName   : String!
    let title       : String!
    let key         : String!
    
    
    // MARK: CustomStringConvertible
    
    var description: String {
        
        var description = ""
        
        description += "imageName       : \(self.imageName)\n"
        description += "title           : \(self.title)\n"
        description += "key             : \(self.key)\n"
        
        return description
    }
    
    init(dictionary: NSDictionary) {
        
        imageName   = dictionary["image"] as! String
        title       = dictionary["title"] as! String
        key         = dictionary["key"] as! String
    }
    
    class func itemsWithArray(_ array: NSArray) -> [MKItem] {
        
        return array.map {
            MKItem(dictionary: $0 as! NSDictionary)
        }
    }
}
