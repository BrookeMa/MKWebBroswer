//
//  PopItemCollectionViewCell.swift
//  MK
//
//  Created by MK on 16/8/14.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class PopItemCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var itemButton: UIButton! {
        didSet {
            
            itemButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet var itemTitleLabel: UILabel!
    
    // MARK: Variables
    
    var delegate: PopSheetCollectionViewTableViewCellDelegate?
    
    var item: MKItem? {
        didSet {
            updateUI()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        itemTitleLabel.sizeToFit()
        
        var myFrame = itemTitleLabel.frame
        myFrame.size.width = self.frame.size.width
        itemTitleLabel.frame = myFrame
    }
    
    func updateUI() {
        
        itemButton.setImage(nil, for: UIControlState())
        itemTitleLabel.text = nil
        
        if let item = self.item {
            
            itemButton.setImage(UIImage(named: item.imageName), for: UIControlState())
            itemTitleLabel.text = item.title
            
        }
    }
    
    @IBAction func itemButtonClick(_ sender: UIButton) {
        
        delegate?.buttonClick(self)
    }
}
