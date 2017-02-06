//
//  PopSheetTableViewController.swift
//  MK
//
//  Created by MK on 16/8/7.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit
import UMSocialCore

class PopSheetTableViewController: UITableViewController {
    
    
    // MARK: Variables
    
    var delegate    : FunctionMenuDelegate!
    var configure   : WebConfigure?
    
    
    var topKeyArray: [String]       = ["WeChat", "WeChatComments", "Weibo", "Safari", "QQ", "QQZone"]
    var bottomKeyArray: [String]    = ["Copy", "Refresh", "Collection", "ResizeFont"]
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNib() {
    
        let nib = UINib(nibName: "PopSheetCollectionViewTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Storyboard.PopSheetCollectionViewTableViewCell)
        
        let nib_1 = UINib(nibName: "PopSheetTopTableViewCell", bundle: nil)
        self.tableView.register(nib_1, forCellReuseIdentifier: Storyboard.PopSheetTopTableViewCell)
        
        let nib_2 = UINib(nibName: "PopSheetBottomCollectionViewTableViewCell", bundle: nil)
        self.tableView.register(nib_2, forCellReuseIdentifier: Storyboard.PopSheetBottomCollectionViewTableViewCell)
        
        let nib_3 = UINib(nibName: "PopCancelTableViewCell", bundle: nil)
        self.tableView.register(nib_3, forCellReuseIdentifier: Storyboard.PopCancelTableViewCell)
    }
    
    func setup() {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PopSheetTopTableViewCell, for: indexPath) as! PopSheetTopTableViewCell
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
            
            return cell
        }
        
        if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PopSheetCollectionViewTableViewCell, for: indexPath) as! PopSheetCollectionViewTableViewCell
            
            cell.urlString = configure?.URL?.host
            cell.delegate = self
            cell.topKeyArray = topKeyArray
            
            return cell
        }
        
        if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PopSheetBottomCollectionViewTableViewCell, for: indexPath) as! PopSheetBottomCollectionViewTableViewCell
            
            cell.urlString = configure?.URL?.host
            cell.delegate = self
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
            cell.bottomKeyArray = bottomKeyArray
            
            return cell
        }
        
        if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PopCancelTableViewCell, for: indexPath) as! PopCancelTableViewCell
            
            return cell
        }
        
        return UITableViewCell()
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 {
            return UI.ScreenHeight - 330
        }
        
        if indexPath.row == 1 {
            return 157
        }
        
        if indexPath.row == 2 {
            return 123
        }
        
        if indexPath.row == 3 {
            return 50
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            dismiss()
        }
        
        if indexPath.row == 3 {
            dismiss()
        }
    }
    
    // MARK: Method
    
    func showAlert(_ title: String, message: String, cancelTitie: String? = "取消", checkTitle: String? = "确认", checkHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let title = title
        let message = message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitie, style: .cancel, handler: nil)
        let check = UIAlertAction(title: checkTitle, style: .default, handler: checkHandler)
        alert.addAction(cancel)
        alert.addAction(check)
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - View

extension PopSheetTableViewController {

    func dismiss(_ completion :FinishedCompletion? = nil) {
        
        self.delegate.removeBlurView(0.3)
        self.dismiss(animated: true) {
            completion?(true)
        }
    }
}


// MARK: - PopSheetTableViewControllerDelegate

extension PopSheetTableViewController: PopSheetTableViewControllerDelegate {
    
    func shareToWeChat() {
        
        let message =  WXMediaMessage()
        
        if let title = configure?.title {
            message.title = title
        }
        if let describe = configure?.describe {
            message.description = describe
        }
        
        let ext =  WXWebpageObject()
        ext.webpageUrl = configure?.URL?.absoluteString
        message.mediaObject = ext
        if let image = configure?.image {
            message.thumbData = UIImageJPEGRepresentation(image, 0.1)
        }
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 0
        
        WXApi.send(req)
    }
    
    func openURLInSafari() {
        UIApplication.shared.openURL((configure?.URL)! as URL)
    }
    
    func shareOnComments() {
        
        let message =  WXMediaMessage()
        
        if let title = configure?.title {
            message.title = title
        }
        
        let ext =  WXWebpageObject()
        ext.webpageUrl = configure?.URL?.absoluteString
        message.mediaObject = ext
        if let image = configure?.image {
            message.thumbData = UIImageJPEGRepresentation(image, 0.1)
        }
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1
        
        WXApi.send(req)
    }
    
    func refreshWeb() {
        self.dismiss()
        delegate.refreshWeb?()
    }
    
    func copyLink() {
        
        UIPasteboard.general.string = configure?.URL?.absoluteString
        self.dismiss { finished in
            if finished == true {
                self.noticeSaveSuccess("已复制", autoClear: true, autoClearTime: 1)
            } else {
                
            }
        }
    }
    
    func shareOnQZone() {
        
        let messageObject = UMSocialMessageObject()
        
        let thumb = configure?.headImageURL?.absoluteString
        let shareObject = UMShareWebpageObject.shareObject(withTitle: configure?.title, descr: configure?.describe, thumImage: thumb)
        shareObject?.webpageUrl = configure?.URL?.absoluteString
        
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: .qzone, messageObject: messageObject, currentViewController: self, completion: { result, error in
            if error != nil {
                
                self.showAlert("请安装QQ空间客户端", message: "")
                
            }
        })
    }
    
    func shareOnQQ() {
        
        let messageObject = UMSocialMessageObject()
        
        let thumb = configure?.headImageURL?.absoluteString
        let shareObject = UMShareWebpageObject.shareObject(withTitle: configure?.title, descr: configure?.describe, thumImage: thumb)
        shareObject?.webpageUrl = configure?.URL?.absoluteString
        
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: .QQ, messageObject: messageObject, currentViewController: self, completion: { result, error in
            if error != nil {
                
                self.showAlert("请安装QQ客户端", message: "")
                
            }
        })
    }
    
    func shareOnWeibo() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let authRequest = WBAuthorizeRequest()
        authRequest.redirectURI = "http://www.sina.com"
        authRequest.scope = "all"
        
        let message = WBMessageObject()
        message.text = self.configure?.URL?.absoluteString
        
        let request = WBSendMessageToWeiboRequest.request(withMessage: message, authInfo: authRequest, access_token: appDelegate.wbtoken) as! WBSendMessageToWeiboRequest
        
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = true
        
        WeiboSDK.send(request)
    }
    
    func resizeFont() {
        self.dismiss { _ in
            self.delegate.showResizeFontViewController?()
        }
    }
    
    func collectWebsite() {
        
        let item = MKCollectItem()
        
        item.webURLString   = configure?.URL?.absoluteString
        item.type           = CollectionType.website.rawValue
        item.id             = UUID().uuidString
        item.title          = configure?.title
        item.offsetX        = configure?.offsetX
        item.offsetY        = configure?.offsetY
        item.timeInterval   = Date().timeIntervalSince1970
        item.headImageData  = configure?.headImageData
        
        let itemEntity = CoreDataManager.inserNewCollectionItemEntity()
        itemEntity.set(collectionItem: item)
        CoreDataManager.saveContext()
        
        self.dismiss { finished in
            if finished == true {
                self.noticeSaveSuccess("已收藏", autoClear: true, autoClearTime: 1)
            } else {
                
            }
        }
    }
    
    
}

