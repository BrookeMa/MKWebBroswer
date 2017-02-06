//
//  MKChooseLogoCollectionViewCell.swift
//  MK
//
//  Created by MK on 2016/11/2.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MKChooseLogoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var logoImageView: UIImageView!
    
    var website: MKWebsite? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        logoImageView.image = nil
        
        if let website = self.website {
            
            logoImageView.image = website.logoImage
            logoImageView.layer.cornerRadius = 5
            logoImageView.clipsToBounds = true
        }
    }
}
