//
//  WebViewController.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit
import WebKit
import MMPopupView
import HTMLReader
import CoreLocation
import Kingfisher

class WebViewController: UIViewController {
    
    
    // MARK: Constants
    
    fileprivate let center = NotificationCenter.default
    fileprivate let configure = WebConfigure()
    
    
    // MARK: Variables
    
    var progressView        : UIProgressView!
    var progressValue       : Float = 0
    var canGoBack           : Bool?
    var canGoForward        : Bool?
    var loading             : Bool?
    var isShowingStatusNotice     = false
    
    
    // MARK: Setting
    
    var initPoint           = CGPoint.zero
    var url                 : URL!
    
    
    // MARK: Store Properties
    
    var isClickedStatusBar: Bool! {
        set {
            UserDefaults.standard.set(newValue, forKey: "")
        }
        get {
            return UserDefaults.standard.bool(forKey: "")
        }
    }
    
    
    // MARK: Computed Properties
    
    let webView: WKWebView = {
        let view = WKWebView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            view.allowsLinkPreview = true
            view.configuration.allowsPictureInPictureMediaPlayback = true
            view.configuration.allowsAirPlayForMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        
        view.configuration.preferences.javaScriptEnabled = true
        view.configuration.allowsInlineMediaPlayback = true
        view.configuration.mediaPlaybackRequiresUserAction = false
        
        if #available(iOS 10.0, *) {
            view.configuration.dataDetectorTypes = .all
        } else {
            // Fallback on earlier versions
        }
        
        return view
    }()

    var longPressGesture: UILongPressGestureRecognizer {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        
        return longPress
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupConfigure()
        setupNotice()
        
        let request = URLRequest(url: url)
        DispatchQueue.main.async(execute: {
            () -> Void in
            
            self.webView.load(request)
        })
        center.addObserver(self, selector: #selector(touchStatusBarClick), name: NSNotification.Name(rawValue: "touchStatusBarClick"), object: nil)
        
        self.navigationController?.hidesBarsWhenVerticallyCompact = false
        
        if navigationController?.navigationBar.isHidden == true {
            self.navigationController?.hidesBarsOnSwipe = true
        } else {
            self.navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeAllObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Method
    
    fileprivate func setupNavigation() {
        
    }
    
    fileprivate func setupWebView() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(webView)
        view.addConstraints(
            NSLayoutConstraint
                .constraints(
                    withVisualFormat: "H:|[webview]|",
                    options: NSLayoutFormatOptions(),
                    metrics: nil,
                    views: ["webview": webView])
        )
        view.addConstraints(
            NSLayoutConstraint
                .constraints(
                    withVisualFormat: "V:[topGuide][webview]|",
                    options: NSLayoutFormatOptions(),
                    metrics: nil,
                    views: ["webview": webView, "topGuide": topLayoutGuide])
        )
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        webView.isUserInteractionEnabled = true
        webView.backgroundColor = UIColor.white
        webView.scrollView.addGestureRecognizer(longPressGesture)
    }
    
    func setupNotice() {
        if isClickedStatusBar == false {
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showTopNotice), userInfo: nil, repeats: false)
        }
    }
    
    func setupConfigure() {
        
        MMPopupWindow.shared().touchWildToHide = true
    }
    
    
    // MARK: - Status Touch Event
    
    func touchStatusBarClick() {
        if isShowingStatusNotice == true {
            self.clearAllNotice()
        }

        self.isClickedStatusBar = true
        if self.navigationController?.isNavigationBarHidden == false {
            webView.scrollView.scrollsToTop = true
        } else {
            webView.scrollView.scrollsToTop = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.hidesBarsOnSwipe = true
        }
    }
    
    
    // MARK: Action
    
    @IBAction func showMoreButtonClick(_ sender: AnyObject) {
        
        
        
        /// Animate Effect
        let maskView = createMaskView()
        self.navigationController!.view.addSubview(maskView)
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: UIViewAnimationOptions(),
                                   animations: {
                                    maskView.alpha = 0.3
            }, completion: {(finish) in
                
                
                
        })
        
        let pstvc = UIStoryboard.popSheetTableViewController()
        
        pstvc.modalPresentationStyle = .overFullScreen
        pstvc.delegate = self
        configure.URL = webView.url
        configure.offsetX = Float(self.webView.scrollView.contentOffset.x)
        configure.offsetY = Float(self.webView.scrollView.contentOffset.y)
        
        pstvc.configure = self.configure
        pstvc.topKeyArray = configureTopKey()
        
        self.present(pstvc, animated: true, completion: nil)
    }
    
    
    // MARK: Method
    
    func loadShareImage() {
        
        let querySelector = "document.getElementsByTagName('img')[0].src"
        
        webView.evaluateJavaScript(querySelector) { (result, error) in
            if let url = result as? String {
                if let URL = URL(string: url) {
                    KingfisherManager.shared.downloader.downloadImage(with: URL, completionHandler: { (image, error, url, data) in
                        if error == nil {
                            self.configure.image            = image
                            self.configure.headImageData    = data as NSData?
                            self.configure.headImageURL     = url
                        } else {
                            self.configure.headImageURL = NSURL(string: "https://mmbiz.qlogo.cn/mmbiz_png/d9Vrw6KEIjBT5hkico76P0LibS44VCNlQIiaAjFzYLt44VTDJEkCl3H8YUct7jAU7W3xia8OkGbELp6UOu2HgWcS7w/0?wx_fmt=png") as URL?
                        }
                    })
                }
            } else {
                
                self.configure.image = UIImage(named: "mk_logo")
                self.configure.headImageData = UIImagePNGRepresentation(UIImage(named: "mk_logo")!) as NSData?
                self.configure.headImageURL = NSURL(string: "https://mmbiz.qlogo.cn/mmbiz_png/d9Vrw6KEIjBT5hkico76P0LibS44VCNlQIiaAjFzYLt44VTDJEkCl3H8YUct7jAU7W3xia8OkGbELp6UOu2HgWcS7w/0?wx_fmt=png") as URL?
            }
        }
    }
    
    func screenShot() {
        
        
    }
    
    func configureTopKey() -> [String] {
        
        var keys = [String]()

        if WXApi.isWXAppInstalled() == true {
            keys.append(contentsOf: ["WeChat", "WeChatComments"])
        }
        keys.append("Weibo")
        keys.append("Safari")
        keys.append("QQ")
        keys.append("QQZone")
        
        return keys
    }
    
    func showTopNotice() {
        self.noticeTop("✋轻触唤出导航栏", autoClear: false, autoClearTime: 10)
        self.isShowingStatusNotice = true
    }
}


// MARK: - WKNavigationDelegate, WKUIDelegate

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadShareImage()
        
        webView.scrollView.setContentOffset(initPoint, animated: false)
        let userEntity = CoreDataManager.getUserEntity()
        setFontSize(userEntity.fontSize)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}


// MARK: Gesture

extension WebViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        
        
        guard recognizer.state == UIGestureRecognizerState.began else { return }
        
        UITouch.cancelPreviousPerformRequests(withTarget: self)
        
        let touchPoint = recognizer.location(in: self.webView)
        
        let js = "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"
        
        self.webView.evaluateJavaScript(js) { (imageURL, error) in
            
            if let url = imageURL as? String {
                self.showCustomActionSheet(url)
            }
        }
        
    }
    
    func showImageOptionsWithUrl(_ imageURL: String) {
        
        
    }
    
    func showCustomActionSheet(_ urlString: String) {
        
        let itemSaveLink =  MMItemMake("收藏", MMItemType.normal) { (index) in
            
            if let URL = URL(string: urlString) {
                KingfisherManager.shared.downloader.downloadImage(with: URL, completionHandler: { (image, error, url, data) in
                    if error == nil {
                        
                        let item = MKCollectItem()
                        
                        item.imageData              = data as NSData?
                        item.id                     = UUID().uuidString
                        item.title                  = self.configure.title
                        item.type                   = CollectionType.photo.rawValue
                        item.webURLString           = self.webView.url?.absoluteString
                        item.imageURLString         = urlString
                        item.offsetX                = Float(self.webView.scrollView.contentOffset.x)
                        item.offsetY                = Float(self.webView.scrollView.contentOffset.y)
                        item.timeInterval           = Date().timeIntervalSince1970
                        item.headImageData          = self.configure.headImageData
                        
                        
                        let colletionItemEntity = CoreDataManager.inserNewCollectionItemEntity()
                        colletionItemEntity.set(collectionItem: item)
                        CoreDataManager.saveContext()
                        
                        self.noticeSaveSuccess("收藏", autoClear: true, autoClearTime: 1)
                    } else {
                        self.noticeSaveFail("收藏失败")
                    }
                })
            }
        }
        
        let itemSaveImage = MMItemMake("保存图片", MMItemType.normal) { (index) in
            
            if let URL = URL(string: urlString) {
                KingfisherManager.shared.downloader.downloadImage(with: URL, completionHandler: { (image, error, url, data) in
                    if error == nil {
                        if let image = image {
                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(WebViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
                        }
                    } else {
                        self.noticeSaveFail("保存失败")
                    }
                })
            }
        }
        
        let sheetView = MMSheetView(title: nil, items: [itemSaveLink!, itemSaveImage!])
        
        sheetView?.attachedView.mm_dimBackgroundBlurEnabled = false
        
        sheetView?.show { (popView, finished) in
            
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            self.noticeSaveSuccess("保存图片", autoClear: true, autoClearTime: 1)
        } else {
            self.noticeSaveFail("保存失败")
        }
    }
}


extension WebViewController {
    
    // MARK: KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                progressChanged(newValue)
            }
        }
        if keyPath == "title" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? String {
                configure.title = newValue
            }
        }
        if keyPath == "loading" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool {
                UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
            }
        }
        if keyPath == "canGoBack" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool {
                canGoBack = newValue
            }
        }
        if keyPath == "canGoForward" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool {
                canGoForward = newValue
            }
        }
    }
    
    fileprivate func progressChanged(_ newValue: NSNumber) {
        if progressView == nil {
            progressView = UIProgressView()
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.tintColor = UIColor.fromRGB(0x44DB5E)
            progressView.backgroundColor = UIColor.clear
            progressView.trackTintColor = UIColor.clear
            progressView.progressViewStyle = .default
            self.view.addSubview(progressView)
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[progressView]-0-|", options: [], metrics: nil, views: ["progressView": progressView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topGuide]-0-[progressView(2)]", options: [], metrics: nil, views: ["progressView": progressView, "topGuide": self.topLayoutGuide]))
        }
        
        DispatchQueue.main.async(execute: {
            
            self.progressView.setProgress(newValue.floatValue, animated: true)
            
            if self.progressView.progress == 1 {
                
                UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.progressView.alpha = 0
                    }, completion: { (finished) in
                        self.progressView.progress = 0
                })
            } else if self.progressView.alpha == 0 {
                UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.curveLinear, animations: { 
                    self.progressView.alpha = 1
                    }, completion: { (finished) in
                        
                })
            }
        })
    }
    
    func loadProgressValue() {
        progressView.setProgress(progressValue, animated: true)
    }
    
    func addKVO() {
        
    }
    
    func removeAllObserver() {
        self.center.removeObserver(self)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
    }
}


// MARK: - WebViewControllerDelegate

extension WebViewController: FunctionMenuDelegate {
    
    func showResizeFontViewController() {
        
        let vc = UIStoryboard.resizeFontTableViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func refreshWeb() {
        
        self.webView.reload()
    }
    
    func createMaskView() -> UIView {
        
        let maskView = UIView()
        
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        maskView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: UI.ScreenHeight)
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        maskView.alpha = 0
        maskView.tag = MKViewTagKey.BlurView
        
        return maskView
    }
    
    func removeBlurView(_ duration: Double) {
        
        for view in navigationController!.view.subviews where view.tag == MKViewTagKey.BlurView {
            UIView.animate(withDuration: duration,
                                       delay: 0,
                                       options: UIViewAnimationOptions(),
                                       animations: {
                                        
                                        view.alpha = 0
                                        
                }, completion: {(finish) in
                    
                    if view.tag == MKViewTagKey.BlurView {
                        view.removeFromSuperview()
                    }
                    
            })
            break
        }
    }
    
    func setFontSize(_ size: Float) {
        
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(size)%'") { (anyobject, error) in
            
        }
    }
}
