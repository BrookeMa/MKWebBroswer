//
//  WebsiteTableViewCell.swift
//  MK
//
//  Created by MK on 16/7/3.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class WebsiteTableViewCell: UITableViewCell {

    var website: MKWebsite! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        self.imageView?.image = nil
        self.textLabel?.text = nil
        
        if let website = self.website {
            
            self.imageView?.image = UIImage(named: website.logo)
            self.textLabel?.text = website.name
            self.imageView?.layer.cornerRadius = 5
        }
    }
}
