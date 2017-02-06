//
//  MKFavoriteWebsiteTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/16.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class MKFavoriteWebsiteTableViewCell: LYSideslipCell {

    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: TTTAttributedLabel!
    
    var item: MKCollectItem? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        headImageView.image     = nil
        dateLabel.text          = nil
        titleLabel.text         = nil
        
        if let item = self.item {
            
            titleLabel.text = item.title
            dateLabel.text = item.date
            if let data = item.headImageData as? Data {
                headImageView.image = UIImage(data: data)
            } else {
                
            }
            titleLabel.verticalAlignment = .top
        }
    }
}
