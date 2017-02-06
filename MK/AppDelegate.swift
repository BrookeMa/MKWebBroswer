//
//  AppDelegate.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit
import CoreData
import WebKit
import UMSocialCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate {

    var window: UIWindow?
    var wbtoken: String?
    var wbCurrentUserID: String?
    
    // MARK: Constants
    
    fileprivate let defaults    = UserDefaults.standard
    fileprivate let center      = NotificationCenter.default
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // WeChat SDK
        WXApi.registerApp("wx04af8a5f308b1d0c", withDescription: "MK")
        clearMemory()
        
        if !self.defaults.bool(forKey: "EverLaunched") {
            self.defaults.set(true, forKey: "EverLaunched")
            self.defaults.set(true, forKey: "FirstLaunch")
            
            loadPlist()
        }
        
        WeiboSDK.registerApp(WeiboKey.AppKey)
        WeiboSDK.enableDebugMode(true)
        
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "582ec0741c5dd00e88000732"
        UMSocialManager.default().setPlaform(.QQ, appKey: "1105831348", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "MK.MK" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MK", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func clearMemory() {
        
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
        
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
    }

    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: self.window)
        if location.y > 0 && location.y < UI.StatubarHeight {
            self.touchStatusBar()
        }
    }
    
    func touchStatusBar() {
        
        self.center.post(name: Notification.Name(rawValue: "touchStatusBarClick"), object: nil)
    }
    
    func loadPlist() {
        
        let plist = NSArray(contentsOfFile: Bundle.main.path(forResource: "Website.plist", ofType: nil)!)!
        
        let websites = MKWebsite.websites(plist)
        
        websites.forEach { (website) in
            let websiteEntity = CoreDataManager.insertNewWebsite()
            websiteEntity.set(website: website)
        }
        
        self.saveContext()
    }
    
    
    // MARK: - WeiboSDKDelegate
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
//        if response.isKind(of: WBSendMessageToWeiboResponse.self) {
//            
//            let sendMessageToWeiboResponse = response as! WBSendMessageToWeiboResponse
//            let accessToken = sendMessageToWeiboResponse.authResponse.userID
//            if accessToken != nil {
//                self.wbtoken = accessToken
//            }
//            
//            let userID = sendMessageToWeiboResponse.authResponse.userID
//            if userID != nil {
//                self.wbCurrentUserID = userID
//            }
//        }
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return WXApi.handleOpen(url, delegate: self)
    }
    
    
    // MARK: - WXApiDelegate
    func onResp(_ resp: BaseResp!) {
        
        if resp.isKind(of: SendMessageToWXResp.self) { //确保是对我们分享操作的回调
            if resp.errCode == WXSuccess.rawValue {  //分享成功
                print("分享成功")
            }else{
                print("分享失败")
            }
        }
        if resp.isKind(of: PayResp.self) {
            if resp.errCode == 0 {
                
            }
        }
    }
}

