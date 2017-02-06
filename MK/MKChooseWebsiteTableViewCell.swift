//
//  MKChooseWebsiteTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/2.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MKChooseWebsiteTableViewCell: UITableViewCell {

    
    @IBOutlet var chooseImageView: UIImageView!
    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var websiteNameLabel: UILabel!
    
    var website: MKWebsite! {
        didSet {
            updateUI()
        }
    }
    var isChosen: Bool! {
        didSet {
            updateChooseImageView()
        }
    }
    func updateUI() {
        
        headImageView.image     = nil
        websiteNameLabel.text   = nil
        
        if let website = self.website {
            
            headImageView.image = UIImage(named: website.logo)
            headImageView.layer.cornerRadius = 5
            websiteNameLabel.text = website.name
        }
    }
    
    func updateChooseImageView() {
        
        chooseImageView.image = nil
        if isChosen == true {
            chooseImageView.image   = UIImage(named: "mk_choose_circle_selected")
        } else {
            chooseImageView.image   = UIImage(named: "mk_choose_cricle")
        }
    }
}
