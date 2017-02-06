//
//  CollectionTableViewController.swift
//  MK
//
//  Created by MK on 2016/11/13.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController {

    var collectionItems = [MKCollectItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setup()
        registerNib()
        loadLocalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return collectionItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.collectionItems[indexPath.section]
        
        if item.type == CollectionType.photo.rawValue {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKFavoriteTableViewCell, for: indexPath) as! MKFavoriteTableViewCell

            // Configure the cell...
            
            cell.delegate = self
            let deleteTagButton = cell.rowAction(with: .normal, title: nil)
            deleteTagButton?.backgroundColor = UIColor.clear
            deleteTagButton?.setImage(UIImage(named: "mk_fav_edit_delete"), for: .normal)
            
            let shareTagButton = cell.rowAction(with: .normal, title: nil)
            shareTagButton?.backgroundColor = UIColor.clear
            shareTagButton?.setImage(UIImage(named: "mk_fav_share"), for: .normal)
            
            
            cell.setRightButtons([shareTagButton!, deleteTagButton!])
            
            
            // Configure Data
            
            cell.item = item
            
            return cell
        }
        
        if item.type == CollectionType.website.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKFavoriteWebsiteTableViewCell, for: indexPath) as! MKFavoriteWebsiteTableViewCell
            
            // Configure the cell...
            
            cell.delegate = self
            let deleteTagButton = cell.rowAction(with: .normal, title: nil)
            deleteTagButton?.backgroundColor = UIColor.clear
            deleteTagButton?.setImage(UIImage(named: "mk_fav_edit_delete"), for: .normal)
            
            let shareTagButton = cell.rowAction(with: .normal, title: nil)
            shareTagButton?.backgroundColor = UIColor.clear
            shareTagButton?.setImage(UIImage(named: "mk_fav_share"), for: .normal)
            
            
            cell.setRightButtons([shareTagButton!, deleteTagButton!])
            
            
            // Configure Data
            
            cell.item = item
            
            return cell
        }
        
        return UITableViewCell()
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.collectionItems[indexPath.section]
        if item.type == CollectionType.photo.rawValue {
            return 220
        }
        if item.type == CollectionType.website.rawValue {
            return 150
        }
        return 220
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.CollectionToWebsiteSegue, sender: collectionItems[indexPath.section])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Storyboard.CollectionToWebsiteSegue {
            let vc = segue.destination as! WebViewController
            let item = sender as! MKCollectItem
            
            vc.url = URL(string: item.webURLString)
            vc.initPoint = CGPoint(x: CGFloat(item.offsetX ?? 0), y: CGFloat(item.offsetY ?? 0))
        }
    }
 
    func setup() {
        tableView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func registerNib() {
        
        let nib = UINib(nibName: "MKFavoriteTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Storyboard.MKFavoriteTableViewCell)
        
        let nib_1 = UINib(nibName: "MKFavoriteWebsiteTableViewCell", bundle: nil)
        self.tableView.register(nib_1, forCellReuseIdentifier: Storyboard.MKFavoriteWebsiteTableViewCell)
    }
    
    func loadLocalData() {
        
        let collectEntities = CoreDataManager.getCollectionItems()
        self.collectionItems = MKCollectItem.items(entities: collectEntities).sorted { $0.timeInterval > $1.timeInterval }
        
    }
}


// MARK: - LYSideslipCellDelegate

extension CollectionTableViewController: LYSideslipCellDelegate {
    
    func sideslipCell(_ sideslipCell: LYSideslipCell!, rowAt indexPath: IndexPath!, didSelectedAt index: Int) {
        
        let item = self.collectionItems[indexPath.section]
        
        if index == 0 {
            
            let maskView = createMaskView()
            self.navigationController!.view.addSubview(maskView)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: UIViewAnimationOptions(),
                           animations: {
                            maskView.alpha = 0.3
            }, completion: {(finish) in
                
                
                
            })
            
            let pstvc = UIStoryboard.popSheetTableViewController()
            
            pstvc.modalPresentationStyle = .overFullScreen
            pstvc.delegate = self
            pstvc.bottomKeyArray = ["Copy"]
            
            let configure = WebConfigure()
            
            configure.URL = URL(string: item.webURLString)
            configure.offsetX = item.offsetX ?? 0
            configure.offsetY = item.offsetY ?? 0
            
            pstvc.configure = configure
            
            self.present(pstvc, animated: true, completion: nil)
            
        }
        
        if index == 1 {
            
            let item = self.collectionItems[indexPath.section]
            CoreDataManager.deleteCollectionItem(id: item.id)
            self.collectionItems.remove(at: indexPath.section)
            
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            sideslipCell.openAllOperation()
        }
    }
    
    func sideslipCell(_ sideslipCell: LYSideslipCell!, canSideslipRowAt indexPath: IndexPath!) -> Bool {
        return true
    }
}


// MARK: - FunctionMenuDelegate

extension CollectionTableViewController: FunctionMenuDelegate {
    
    func createMaskView() -> UIView {
        
        let maskView = UIView()
        
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        maskView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: UI.ScreenHeight)
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        maskView.alpha = 0
        maskView.tag = MKViewTagKey.BlurView
        
        return maskView
    }
    
    func removeBlurView(_ duration: Double) {
        
        for view in navigationController!.view.subviews where view.tag == MKViewTagKey.BlurView {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIViewAnimationOptions(),
                           animations: {
                            
                            view.alpha = 0
                            
            }, completion: {(finish) in
                
                if view.tag == MKViewTagKey.BlurView {
                    view.removeFromSuperview()
                }
                
            })
            break
        }
    }
}
