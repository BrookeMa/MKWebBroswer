//
//  PopSheetBottomCollectionViewTableViewCell.swift
//  MK
//
//  Created by MK on 16/8/21.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class PopSheetBottomCollectionViewTableViewCell: UITableViewCell {

    
    // MARK: Variables
    
    var items = [MKItem]()
    var collectionView: UICollectionView!
    var delegate: PopSheetTableViewControllerDelegate?
    var bottomKeyArray: [String]? {
        didSet {
            filterItems()
        }
    }
    
    
    // MARK: Computed Properties
    
    var urlString: String! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addBlurEffectView()
        setup()
    }
    
    func setup() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 60, height: 94)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 15, width: UI.ScreenWidth, height: 99), collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        
        registerNib()
        self.addSubview(collectionView)
    }

    func addBlurEffectView() {
        
        let view = UIView()
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: 123)
            
            view.addSubview(blurEffectView)
        } else {
            
            view.backgroundColor = UIColor.white
        }
        
        self.addSubview(view)
    }
    
    func updateUI() {
        
    }
    
    func filterItems() {
        
        if let bottomKeyArray = self.bottomKeyArray {
            let plist = NSArray(contentsOfFile: Bundle.main.path(forResource: "WebSiteHandle.plist", ofType: nil)!)!
            items = MKItem.itemsWithArray(plist).filter { bottomKeyArray.contains($0.key) }
            collectionView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PopSheetBottomCollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func registerNib() {
        
        let nib = UINib(nibName: "PopItemCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: Storyboard.PopItemCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.PopItemCollectionViewCell, for: indexPath)
            as! PopItemCollectionViewCell
        
        cell.item = items[(indexPath as NSIndexPath).item]
        cell.delegate = self
        
        return cell
    }
    
}


// MARK: - PopSheetCollectionViewTableViewCellDelegate

extension PopSheetBottomCollectionViewTableViewCell: PopSheetCollectionViewTableViewCellDelegate {
    
    func buttonClick(_ cell: UICollectionViewCell) {
        
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        
        let key = items[(indexPath as NSIndexPath).item].key
        
        switch key {
        case HandleKey.Copy?:
            delegate?.copyLink()
            break
        case HandleKey.Refresh?:
            delegate?.refreshWeb()
            break
        case HandleKey.ResizeFont?:
            delegate?.resizeFont()
        case HandleKey.Collection?:
            delegate?.collectWebsite()
        default: break
            
        }
    }
}
