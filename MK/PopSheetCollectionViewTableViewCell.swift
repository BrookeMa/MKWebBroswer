//
//  PopSheetCollectionViewTableViewCell.swift
//  MK
//
//  Created by MK on 16/8/7.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class PopSheetCollectionViewTableViewCell: UITableViewCell {

    
    // MARK: Variables
    
    var items = [MKItem]()
    var collectionView: UICollectionView!
    var delegate: PopSheetTableViewControllerDelegate?
    
    
    // MARK: Constants
    
    let titleLabel: UILabel = UILabel()
    
    var topKeyArray: [String]? {
        didSet {
            filterItems()
        }
    }
    var urlString: String! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addBlurEffectView()
        configureLabel()
        setup()
    }
    
    func setup() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 60, height: 94)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 45, width: UI.ScreenWidth, height: 99), collectionViewLayout: layout)
        
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
            blurEffectView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: 157)
            
            view.addSubview(blurEffectView)
        } else {
            
            view.backgroundColor = UIColor.white
        }
        
        self.addSubview(view)
    }
    
    func configureLabel() {
        
        titleLabel.frame = CGRect(x: 8, y: 8, width: UI.ScreenWidth - 16, height: 20)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(titleLabel)
    }
    
    func updateUI() {
        
        titleLabel.text = nil
        if let urlString = self.urlString {
            
            titleLabel.text = urlString
            
        }
    }
    
    func filterItems() {
        
        if let topKeyArray = topKeyArray {
            let plist = NSArray(contentsOfFile: Bundle.main.path(forResource: "Items.plist", ofType: nil)!)!
            items = MKItem.itemsWithArray(plist).filter { topKeyArray.contains($0.key) }
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PopSheetCollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        
        cell.item = items[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}


// MARK: - PopSheetCollectionViewTableViewCellDelegate

extension PopSheetCollectionViewTableViewCell: PopSheetCollectionViewTableViewCellDelegate {
    
    func buttonClick(_ cell: UICollectionViewCell) {
        
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        
        let key = items[(indexPath as NSIndexPath).item].key
        
        switch key {
        case WebKey.WeChat?:
            delegate?.shareToWeChat()
        case WebKey.WeChatComments?:
            delegate?.shareOnComments()
        case WebKey.Safari?:
            delegate?.openURLInSafari()
        case WebKey.QQZone?:
            delegate?.shareOnQZone()
        case WebKey.QQ?:
            delegate?.shareOnQQ()
        case WebKey.Weibo?:
            delegate?.shareOnWeibo()
        default:
            break
        }
    }
}
