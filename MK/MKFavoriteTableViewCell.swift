//
//  MKFavoriteTableViewCell.swift
//  MK
//
//  Created by MK on 2016/11/13.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit


class MKFavoriteTableViewCell: LYSideslipCell {

    @IBOutlet var collectionImageView: UIImageView!
    @IBOutlet var collectionItemTitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    var item: MKCollectItem? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        collectionImageView.image = nil
        collectionItemTitleLabel.text = nil
        dateLabel.text = nil
        
        if let item = item {
         
            collectionImageView.image = item.image
            collectionItemTitleLabel.text = item.title
            dateLabel.text = item.date
        }
    }
}
