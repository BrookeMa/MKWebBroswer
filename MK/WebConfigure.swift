//
//  WebConfigure.swift
//  MK
//
//  Created by MK on 16/8/21.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation

class WebConfigure: CustomStringConvertible {
    
    
    var title           : String?
    var image           : UIImage?
    var headImageData   : NSData?
    var headImageURL    : URL?
    var URL             : Foundation.URL?
    var offsetX         : Float = 0
    var offsetY         : Float = 0
    
    var describe: String? {
        
        if let title = self.title {
            
            if title.contains("【") {
                return "\(title)分享给你的网站"
            } else {
                return "【\(title)】分享给你的网站"
            }
        }
        return URL?.absoluteString
    }
    
    var description: String {
        
        var description = ""
        
        description += "title:         \(title)\n"
        description += "image:         \(image)\n"
        description += "URL:           \(URL)\n"
        
        return description
    }
    
    init() {}
}
