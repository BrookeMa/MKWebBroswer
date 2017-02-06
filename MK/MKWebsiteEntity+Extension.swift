//
//  MKWebsite+Extension.swift
//  MK
//
//  Created by MK on 2016/10/28.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


extension MKWebsiteEntity {
    
    func set(website: MKWebsite) {
        
        id                  = website.id
        urlString           = website.urlString
        name                = website.name
        introduction        = website.introduction
        logo                = website.logo
        character           = website.character
        status              = website.status
    }
}
