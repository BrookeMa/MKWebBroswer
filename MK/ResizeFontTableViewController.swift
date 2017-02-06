//
//  ResizeFontTableViewController.swift
//  MK
//
//  Created by MK on 16/9/4.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class ResizeFontTableViewController: UITableViewController {
    
    var delegate: FunctionMenuDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerNib()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNib() {
        
        let nib = UINib(nibName: "PopSheetTopTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Storyboard.PopSheetTopTableViewCell)
        
        let nib_1 = UINib(nibName: "FontSizeTableViewCell", bundle: nil)
        self.tableView.register(nib_1, forCellReuseIdentifier: Storyboard.FontSizeTableViewCell)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.PopSheetTopTableViewCell, for: indexPath) as! PopSheetTopTableViewCell
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.FontSizeTableViewCell, for: indexPath) as! FontSizeTableViewCell
            
            cell.delegate = self
            
            let userEntity = CoreDataManager.getUserEntity()
            
            cell.fontSize = userEntity.fontSize
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0 {
            return UI.ScreenHeight - 140
        } else {
            return 140
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - ResizeFontTableViewControllerDelegate

extension ResizeFontTableViewController: ResizeFontTableViewControllerDelegate {
    
    func resizeFont(_ size: Float) {
        
        let userEntity = CoreDataManager.getUserEntity()
        
        userEntity.fontSize = size
        
        CoreDataManager.saveContext()
        
        delegate?.setFontSize?(size)
    }
}
