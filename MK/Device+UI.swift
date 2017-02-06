//
//  Device+UI.swift
//  MK
//
//  Created by MK on 2016/11/22.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


struct Device {
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_HEIGHT < 568)
    static let IS_IPHONE_5 = (IS_IPHONE && SCREEN_HEIGHT == 568.0)
    static let IS_IPHONE_6 = (IS_IPHONE && SCREEN_HEIGHT == 667.0)
    
    static let IS_IPHONE_6P = (IS_IPHONE && SCREEN_HEIGHT >= 736.0)
    
    static let IS_IPHONE_5_6_6P = IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6P
}

struct UI {
    
    static let ScreenBounds = UIScreen.main.bounds
    static let ScreenSize   = ScreenBounds.size
    static let ScreenWidth  = ScreenSize.width
    static let ScreenHeight = ScreenSize.height
    
    static let GridWidth : CGFloat                  = 155.0
    static let NavigationHeight : CGFloat           = 44.0
    static let StatubarHeight : CGFloat             = 20.0
    static let TabBarHeight: CGFloat                = 49.0
    
    static let NavigationHeaderAndStatusbarHeight : CGFloat = 64.0
    
    static let CollectionCellHeight_IPhone_5: CGFloat       = 237
    static let CollectionCellHeight_IPhone_6: CGFloat       = 247
    static let CollectionCellHeight_IPhone_6P: CGFloat      = 285
}
