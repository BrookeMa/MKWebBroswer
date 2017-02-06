//
//  MainViewController.swift
//  MK
//
//  Created by MK on 2016/11/2.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    // MARK: Views
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    let blurEffectView  = UIVisualEffectView()
    var searchTableView: UITableView!
    let rvc = UITableViewController(style: .plain)
    
    
    // MARK: Variables
    
    var websites: [MKWebsite]!
    var websitesArray: [[MKWebsite]]        = [[MKWebsite]]()
    var searchResultWebsites                = [MKWebsite]()
    var allWebsites                         = [MKWebsite]()
    var characters          : [String]!
    var searchController    : UISearchController!
    var searchBarText       = ""
    var lastCopyString      = ""
    var isFirstAppear       = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadCoreData()
        setup()
        configureSearchTableView()
        registerNib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppear == false {
            if let index = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: index, animated: false)
            }
            if let index = self.searchTableView.indexPathForSelectedRow {
                self.searchTableView.deselectRow(at: index, animated: false)
            }
            if let index = self.rvc.tableView.indexPathForSelectedRow {
                self.rvc.tableView.deselectRow(at: index, animated: false)
            }
        } else {
            isFirstAppear = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNib() {
        
        /// tableView
        
        let nib = UINib(nibName: "WebsiteTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Storyboard.WebsiteTableViewCell)
        
        let nib_1 = UINib(nibName: "ItemTableViewCell", bundle: nil)
        self.tableView.register(nib_1, forCellReuseIdentifier: Storyboard.ItemTableViewCell)
        
        
        /// searchTableView
        
        let snib = UINib(nibName: "MKCopyLinkTableViewCell", bundle: nil)
        self.searchTableView.register(snib, forCellReuseIdentifier: Storyboard.MKCopyLinkTableViewCell)
        
    }
    
    func loadCoreData() {
        
        let websiteEntities = CoreDataManager.getWebsites()
        
        self.websites = MKWebsite.websitesWithEntities(websiteEntities).filter { $0.status == "1" }
        self.allWebsites = MKWebsite.websitesWithEntities(websiteEntities)
        characters = websites.map {
            $0.character
            }.unique().sorted (by: <)
        
        if characters.contains("#") {
            
            characters.remove(at: 0)
            characters.append("#")
        }
        
        for character in characters {
            
            let array = websites.filter {
                return $0.character == character
            }
            
            websitesArray.append(array)
        }
        
        characters.insert(UITableViewIndexSearch, at: 0)
    }
    
    func setup() {
        
        rvc.tableView.delegate = self
        rvc.tableView.dataSource = self
        rvc.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        
        let snib = UINib(nibName: "MKChooseTypeTableViewCell", bundle: nil)
        rvc.tableView.register(snib, forCellReuseIdentifier: Storyboard.MKChooseTypeTableViewCell)
        
        self.searchController                                   = UISearchController(searchResultsController: rvc)
        self.searchController.searchBar.placeholder             = "搜索或输入网址"
        self.searchController.searchBar.barTintColor            = UIColor.groupTableViewBackground
        self.searchController.searchBar.delegate                = self
        self.searchController.searchBar.layer.borderColor       = UIColor.groupTableViewBackground.cgColor
        self.searchController.searchBar.layer.borderWidth       = 1
        
        
        self.searchController.searchResultsUpdater              = self
        self.searchController.dimsBackgroundDuringPresentation  = false
        self.searchController.delegate                          = self
        self.searchController.searchResultsUpdater              = self
        
        
        definesPresentationContext = true
        
        self.searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        
        if let string = UIPasteboard.general.string {
            lastCopyString = string
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Storyboard.MainToWebSegue {
            
            let vc = segue.destination as! WebViewController
            
            if var urlString = sender as? String {
                
                if !urlString.contains("http") {
                    urlString = "http://" + urlString
                }
                
                let url = URL(string: urlString)
                vc.url = url
            }
            
        } else if segue.identifier == Storyboard.ShowChooseViewSegue {
            
            let vc = segue.destination as! ChoosePopoverTableViewController
            
            vc.modalPresentationStyle = .none
            vc.popoverPresentationController!.delegate = self
            vc.preferredContentSize = CGSize(width: 120, height: 87)
            vc.delegate = self
            
        } else if segue.identifier == Storyboard.MainToChooseWebsiteSegue {
            
            let vc = segue.destination.childViewControllers[0] as! ChooseWebsiteViewController
            
            vc.delegate = self
            
        } else if segue.identifier == Storyboard.MainToCollectionSegue {
            
            let _ = segue.destination as! CollectionTableViewController
        }
    }
    
    // MARK: - UI
    
    func configureSearchTableView() {
        
        self.searchTableView = UITableView()
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        self.searchTableView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: UI.ScreenHeight - 64)
        self.searchTableView.layer.zPosition = 9
        self.searchTableView.backgroundColor = UIColor.clear
        self.searchTableView.separatorStyle = .none
        self.searchController.definesPresentationContext = true
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        
        blurEffectView.effect = blurEffect
        blurEffectView.frame = CGRect(x: 0, y: 64, width: UI.ScreenWidth, height: UI.ScreenHeight - 64)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 1
        blurEffectView.isHidden = true
        
        blurEffectView.addSubview(self.searchTableView)
        self.view.addSubview(blurEffectView)
    }
    
    // TODO: Action
    
    @IBAction func addButtonClick(_ sender: Any) {
        
        showChooseWebsiteViewController()
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        
        if let urlString = urlString {
            if let url  = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) == true {
                    return true
                }
            }
        }
        
        return false
    }

    func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "^(?i)(?:(?:https?|ftp):\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:\\/[^\\s]*)?$"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == self.tableView {
            return websitesArray.count + 1
        } else if tableView == self.searchTableView {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            if section == 0 {
                return 1
            } else {
                return websitesArray[section - 1].count
            }
        } else if tableView == self.searchTableView {
            
            if verifyUrl(urlString: UIPasteboard.general.string) {
                return 1
            } else {
                return 0
            }
           
        } else {
            return searchResultWebsites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if indexPath.section == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ItemTableViewCell, for: indexPath) as! ItemTableViewCell
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.WebsiteTableViewCell, for: indexPath) as! WebsiteTableViewCell
                
                cell.website = websitesArray[indexPath.section - 1][indexPath.row]
                
                return cell
            }
        } else if tableView == self.searchTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKCopyLinkTableViewCell, for: indexPath) as! MKCopyLinkTableViewCell
            if #available(iOS 10.0, *) {
                if UIPasteboard.general.hasStrings {
                    cell.link = UIPasteboard.general.string
                }
            } else {
                // Fallback on earlier versions
                cell.link = UIPasteboard.general.string
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKChooseTypeTableViewCell, for: indexPath) as! MKChooseTypeTableViewCell

            cell.keyWord = self.searchBarText
            cell.website = searchResultWebsites[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 44
        } else if tableView == self.searchTableView {
            return 55
        } else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if indexPath.section == 0 {
                performSegue(withIdentifier: Storyboard.MainToCollectionSegue, sender: nil)
            } else {
                performSegue(withIdentifier: Storyboard.MainToWebSegue, sender: websitesArray[indexPath.section - 1][indexPath.row].urlString)
            }
        } else if tableView == self.searchTableView {
            if let string = UIPasteboard.general.string {
                performSegue(withIdentifier: Storyboard.MainToWebSegue, sender: string)
            }
            
        } else {
            performSegue(withIdentifier: Storyboard.MainToWebSegue, sender: searchResultWebsites[indexPath.row].urlString)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            if section == 0 {
                return 0
            } else {
                return 20
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            if section == 0 {
                return nil
            } else {
                
                let label = UILabel()
                label.text = characters[section]
                label.frame = CGRect(x: 8, y: 0, width: 200, height: 20)
                label.font = UIFont.systemFont(ofSize: 12)
                let view = UIView()
                view.backgroundColor = UIColor.groupTableViewBackground
                view.addSubview(label)
                
                return view
            }
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == self.tableView {
            return characters
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if tableView == self.tableView {
            if title == UITableViewIndexSearch {
                tableView.setContentOffset(CGPoint(x: 0, y: -64), animated: false)
                return NSNotFound
            } else {
                return index
            }
        } else {
            return 0
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if tableView == self.tableView {
            if indexPath.section == 0 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let websiteEntities = CoreDataManager.getWebsites()
            let id = websitesArray[indexPath.section - 1][indexPath.row].id
            websiteEntities.filter({ $0.id! == id! }).first?.status = "0"
            CoreDataManager.saveContext()
            if self.websitesArray[indexPath.section - 1].count == 1 {
                
                self.websitesArray.remove(at: indexPath.section - 1)
                self.characters.remove(at: indexPath.section)
                self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
                
            } else {
                self.websitesArray[indexPath.section - 1].remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}


// MARK: - UIPopoverPresentationControllerDelegate

extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if lastCopyString != UIPasteboard.general.string && UIPasteboard.general.string != "" {
            self.searchTableView.reloadData()
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if validateUrl(urlString: searchBar.text!) == true {
            self.performSegue(withIdentifier: Storyboard.MainToWebSegue, sender: searchBar.text!)
        } else {
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarText = searchBar.text!
        self.searchResultWebsites = self.allWebsites.filter({ return $0.name.contains(searchBar.text!) || $0.url!.host!.contains(searchBar.text!) })
        self.rvc.tableView.reloadData()
    }
}


// MARK: - UISearchDisplayDelegate

extension MainViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        blurEffectView.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        blurEffectView.isHidden = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        
    }
}


// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


// MARK: - MainViewControllerDelegate

extension MainViewController: MainViewControllerDelegate {
    
    func showChooseWebsiteViewController() {
        
        self.performSegue(withIdentifier: Storyboard.MainToChooseWebsiteSegue, sender: nil)
    }
    
    func reloadDataAndView() {
        self.websitesArray.removeAll()
        self.loadCoreData()
        self.tableView.reloadData()
    }
}


// MARK: - UITextFieldDelegate

extension MainViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
