//
//  Constant.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    
    // MARK: MainViewController
    
    static let WebsiteTableViewCell                         = "Website TableView Cell"
    static let MainToWebSegue                               = "Main To Web Segue"
    static let PopSheetCollectionViewTableViewCell          = "Pop Sheet CollectionView TableView Cell"
    static let PopSheetTopTableViewCell                     = "Pop Sheet Top TableView Cell"
    static let PopItemCollectionViewCell                    = "Pop Item CollectionView Cell"
    static let PopCancelTableViewCell                       = "Pop Cancel TableView Cell"
    static let PopSheetBottomCollectionViewTableViewCell    = "Pop Sheet Bottom CollectionView TableView Cell"
    static let ItemTableViewCell                            = "Item TableView Cell"
    
    
    // MARK: ResizeFontTableViewController
    
    static let FontSizeTableViewCell                        = "Font Size TableView Cell"
    
    
    // MARK: ChooseWebsiteViewController
    
    static let MKSearchCollectionViewCell                   = "MKSearch CollectionView Cell"
    static let MKChooseWebsiteTableViewCell                 = "MKChoose Website TableView Cell"
    static let MKChooseLogoCollectionViewCell               = "MKChoose Logo CollectionView Cell"
    static let MKChooseWebsiteEmptyTableViewCell            = "MKChoose Website Empty TableView Cell"
    static let MKChooseWebsiteInSearchTableViewCell         = "MKChoose Website In Search TableView Cell"
    static let MKCopyLinkTableViewCell                      = "MKCopy Link TableView Cell"
    static let MKChooseTypeTableViewCell                    = "MKChoose Type TableView Cell"
    
    
    // MARK: CollectionTableViewController
    
    static let MKFavoriteTableViewCell                      = "MKFavorite TableView Cell"
    static let MKFavoriteWebsiteTableViewCell               = "MKFavorite Website TableView Cell"
    
    
    // MARK: Segue
    
    static let ShowChooseViewSegue                          = "Show Choose View Segue"
    static let MainToChooseWebsiteSegue                     = "Main To Choose Website Segue"
    static let MainToCollectionSegue                        = "Main To Collection Segue"
    static let CollectionToWebsiteSegue                     = "Collection To Website Segue"
    
}

struct MKViewTagKey {
    
    static let RedDot   = 1023
    static let BlurView = 1024
}


struct CoreDataConstant {
    static let MKWebsiteEntityKey               = "MKWebsiteEntity"
    static let MKCollectionEntityKey            = "MKCollectionEntity"
}

struct WeiboKey {
    static let AppKey = "62362154"
}
