//
//  Delegate.swift
//  MK
//
//  Created by MK on 16/8/7.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation

typealias FinishedCompletion = (Bool) -> ()


@objc protocol FunctionMenuDelegate {
    func removeBlurView(_ duration: Double)
    @objc optional func refreshWeb()
    @objc optional func showResizeFontViewController()
    @objc optional func setFontSize(_ size: Float)
}

protocol PopSheetCollectionViewTableViewCellDelegate {
    func buttonClick(_ cell: UICollectionViewCell)
}

protocol PopSheetTableViewControllerDelegate {
    func shareToWeChat()
    func openURLInSafari()
    func shareOnComments()
    func shareOnWeibo()
    func refreshWeb()
    func copyLink()
    func shareOnQQ()
    func shareOnQZone()
    func resizeFont()
    func collectWebsite()
}

protocol ResizeFontTableViewControllerDelegate {
    func resizeFont(_ size: Float)
}

protocol MainViewControllerDelegate {
    func showChooseWebsiteViewController()
    func reloadDataAndView()
}
