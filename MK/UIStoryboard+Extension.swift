//
//  UIStoryboard+Extension.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func webViewController() -> WebViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
    }
    
    class func searchResultTableViewController() -> SearchResultTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "SearchResultTableViewController") as! SearchResultTableViewController
    }
    
    class func popSheetTableViewController() -> PopSheetTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "PopSheetTableViewController") as! PopSheetTableViewController
    }
    
    class func resizeFontTableViewController() -> ResizeFontTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "ResizeFontTableViewController") as! ResizeFontTableViewController
    }
    
    class func chooseWebsiteViewController() -> ChooseWebsiteViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "ChooseWebsiteViewController") as! ChooseWebsiteViewController
    }
    
    class func collectionTableViewController() -> CollectionTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "CollectionTableViewController") as! CollectionTableViewController
    }
}
