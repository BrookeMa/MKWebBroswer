//
//  URLTester.swift
//  MK
//
//  Created by MK on 2016/11/7.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation


class URLTester {
    
    class func verifyURL(urlPath: String, completion: @escaping (_ isOK: Bool)->()) {
        if let url = NSURL(string: urlPath) {
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (_, response, error) in
                if let httpResponse = response as? HTTPURLResponse, error == nil {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }
}
