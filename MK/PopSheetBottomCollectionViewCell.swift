//
//  PopSheetBottomCollectionViewCell.swift
//  MK
//
//  Created by MK on 16/8/16.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class PopSheetBottomCollectionViewCell: UICollectionViewCell {

    
    // MARK: Variables
    
    var items = [MKItem]()
    var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addBlurEffectView()
    }
    
    func setup() {
    
    }
    
    func addBlurEffectView() {
        
        let view = UIView()
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: 330)
            
            view.addSubview(blurEffectView)
        } else {
            
            view.backgroundColor = UIColor.white
        }
        
        self.addSubview(view)
    }

}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PopSheetBottomCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func registerNib() {
        
        let nib = UINib(nibName: "PopItemCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: Storyboard.PopItemCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.PopItemCollectionViewCell, for: indexPath)
            as! PopItemCollectionViewCell
        
        cell.item = items[(indexPath as NSIndexPath).item]
        
        return cell
    }
}
