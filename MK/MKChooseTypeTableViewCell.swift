//
//  MKChooseTypeTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/8.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MKChooseTypeTableViewCell: UITableViewCell {

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    var keyWord: String!
    
    var website: MKWebsite? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.attributedText = nil
        detailLabel.attributedText = nil
        logoImageView.image = nil
        if let website = self.website {
            
            titleLabel.attributedText = configureAttribute(string: website.name)
            detailLabel.attributedText = configureAttribute(string:website.url!.host!)
            logoImageView.image = website.logoImage
        }
    }
    
    
    func configureAttribute(string: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: string)
        
        let range = (string as NSString).range(of: keyWord)
        
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRGB(0x0076FF), range: range)
        
        return attributedText
    }
}
