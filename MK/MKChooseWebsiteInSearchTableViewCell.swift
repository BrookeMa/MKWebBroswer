//
//  MKChooseWebsiteInSearchTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/4.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MKChooseWebsiteInSearchTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var chooseImageView: UIImageView!
    
    var keyWord: String!
    
    var website: MKWebsite? {
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
        titleLabel.attributedText = nil
        detailLabel.attributedText = nil
        logoImageView.image = nil
        if let website = self.website {
            
            titleLabel.attributedText = configureAttribute(string: website.name)
            detailLabel.attributedText = configureAttribute(string:website.url!.host!)
            logoImageView.image = website.logoImage
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
    
    func configureAttribute(string: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: string)
        
        let range = (string as NSString).range(of: keyWord)
        
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRGB(0x0076FF), range: range)
        
        return attributedText
    }
}
