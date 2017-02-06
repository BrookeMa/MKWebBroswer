//
//  MKCopyLInkTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/6.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MKCopyLinkTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    var link: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        
        if let link = self.link {
            titleLabel.text = "您复制的链接"
            subtitleLabel.text = link
        }
    }
}
