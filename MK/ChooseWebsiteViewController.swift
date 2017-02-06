//
//  ChooseWebsiteViewController.swift
//  MK
//
//  Created by MK on 2016/10/29.
//  Copyright © 2016年 MK. All rights reserved.
//

import UIKit

class ChooseWebsiteViewController: UIViewController {

    
    // MARK: View
    
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var searchTableView : UITableView!
    var collectionView  : UICollectionView!
    let textField       = UITextField()
    let searchImageView = UIImageView()
    let blurEffectView  = UIVisualEffectView()
    
    
    // MARK: Varibles
    
    var selectedWebsites                = [MKWebsite]()
    var websites                        = [MKWebsite]()
    var websitesArray: [[MKWebsite]]    = [[MKWebsite]]()
    var searchResultWebsites            = [MKWebsite]()
    var characters: [String]!
    var delegate: MainViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCoreData()
        setup()
        registerNib()
        addKVO()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNib() {
        
        
        /// register tableView cell
        
        let tvnib = UINib(nibName: "MKChooseWebsiteTableViewCell", bundle: nil)
        self.tableView.register(tvnib, forCellReuseIdentifier: Storyboard.MKChooseWebsiteTableViewCell)
        
        
        /// register searchTableView cell
        
        let stvnib = UINib(nibName: "MKChooseWebsiteEmptyTableViewCell", bundle: nil)
        self.searchTableView.register(stvnib, forCellReuseIdentifier: Storyboard.MKChooseWebsiteEmptyTableViewCell)
        
        let stvnib_1 = UINib(nibName: "MKChooseWebsiteInSearchTableViewCell", bundle: nil)
        self.searchTableView.register(stvnib_1, forCellReuseIdentifier: Storyboard.MKChooseWebsiteInSearchTableViewCell)
        
        /// register collection cell
        
        let cvnib = UINib(nibName: "MKChooseLogoCollectionViewCell", bundle: nil)
        self.collectionView.register(cvnib, forCellWithReuseIdentifier: Storyboard.MKChooseLogoCollectionViewCell)
    }
    
    func loadCoreData() {
        
        let selectedWebsiteEntites = CoreDataManager.getWebsites().filter { $0.status == "1" }
        
        self.selectedWebsites = MKWebsite.websitesWithEntities(selectedWebsiteEntites)
        
        let websiteEntities = CoreDataManager.getWebsites()
        
        self.websites = MKWebsite.websitesWithEntities(websiteEntities)
        
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
    
    func addKVO() {
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    func setup() {
        
        configureLine()
        configureTextField()
        configureSearchImageView()
        configureCollectionView()
        configureSearchTableView()
    }
    
    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: 33, height: 54)
        
        layout.minimumLineSpacing       = 8
        layout.minimumInteritemSpacing  = 8
        layout.sectionInset             = UIEdgeInsetsMake(0, 15, 0, 0)
        layout.scrollDirection          = .horizontal
        layout.itemSize                 = CGSize(width: 36, height: 36)
        
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        self.collectionView.delegate                = self
        self.collectionView.dataSource              = self
        self.collectionView.backgroundColor         = UIColor.clear
        self.collectionView.bounces                 = false
        
        
        self.view.addSubview(self.collectionView)
    }
    
    func configureSearchImageView() {
        
        searchImageView.frame = CGRect(x: 15, y: 0, width: 18, height: 54)
        searchImageView.image = UIImage(named: "mk_search")
        searchImageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(searchImageView)
    }
    
    func configureLine() {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 54, width: UI.ScreenWidth, height: 1)
        view.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addSubview(view)
    }
    
    func configureTextField() {
        
        textField.placeholder   = "搜索"
        textField.font          = UIFont.systemFont(ofSize: 15)
        textField.frame         = CGRect(x: 36, y: 0, width: UI.ScreenWidth - 34, height: 54)
        textField.delegate      = self
        textField.returnKeyType = .search
        
        self.view.addSubview(textField)
    }
    
    func configureSearchTableView() {
        
        self.searchTableView = UITableView()
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        self.searchTableView.frame = CGRect(x: 0, y: 0, width: UI.ScreenWidth, height: UI.ScreenHeight - 55 - 64)
        self.searchTableView.layer.zPosition = 9
        self.searchTableView.backgroundColor = UIColor.clear
        self.searchTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        let blurEffect = UIBlurEffect(style: .light)
        
        blurEffectView.effect = blurEffect
        blurEffectView.frame = CGRect(x: 0, y: 55, width: UI.ScreenWidth, height: UI.ScreenHeight - 55)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 1
        blurEffectView.isHidden = true
        
        blurEffectView.addSubview(self.searchTableView)
        self.view.addSubview(blurEffectView)
    }
    
    func updateUI() {
        
        let count = self.selectedWebsites.count
        
        if count == 0 {
            self.collectionView.frame   = CGRect(x: 0, y: 0, width: 33, height: 54)
            self.textField.frame        = CGRect(x: 36, y: 0, width: UI.ScreenWidth - 34, height: 54)
            self.searchImageView.isHidden = false
            
            UIView.setAnimationsEnabled(false)
            self.doneBarButtonItem.title = "确定"
            self.doneBarButtonItem.isEnabled = false
            UIView.setAnimationsEnabled(true)
            
        } else {
            
            var x = min(count, 6)
            if Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS {
                x = min(count, 5)
            }
            
            let detla: CGFloat = CGFloat(x * 44)
            self.collectionView.frame   = CGRect(x: 0, y: 0, width: detla + 15, height: 54)
            textField.frame        = CGRect(x: detla + 14, y: 0, width: UI.ScreenWidth - 34 - detla, height: 54)
            self.searchImageView.isHidden = true
            
            UIView.setAnimationsEnabled(false)
            self.doneBarButtonItem.title = "确定(\(count))"
            self.doneBarButtonItem.isEnabled = true
            UIView.setAnimationsEnabled(true)
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        let websiteEntities = CoreDataManager.getWebsites()
        
        websiteEntities.forEach { website in
            
            if selectedWebsites.contains(where: { return $0.id == website.id }) {
                website.status = "1"
            } else {
                website.status = "0"
            }
        }
        CoreDataManager.saveContext()
        
        self.delegate.reloadDataAndView()
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChooseWebsiteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableView == tableView {
            return websitesArray.count
        } else {
            if textField.text?.isEmpty == true {
                return 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableView == tableView {
            return websitesArray[section].count
        } else {
            if textField.text?.isEmpty == true {
                return 1
            } else {
                return searchResultWebsites.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableView == tableView {
            
            let website = websitesArray[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKChooseWebsiteTableViewCell, for: indexPath) as! MKChooseWebsiteTableViewCell
            
            cell.website = website
            
            if selectedWebsites.contains(where: { return $0.id == website.id }) {
                cell.isChosen = true
            } else {
                cell.isChosen = false
            }
            
            return cell
            
        } else {
            
            if textField.text?.isEmpty == true {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKChooseWebsiteEmptyTableViewCell, for: indexPath) as! MKChooseWebsiteEmptyTableViewCell
                
                cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
                
                return cell
                
            } else {
                let website = searchResultWebsites[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MKChooseWebsiteInSearchTableViewCell, for: indexPath) as! MKChooseWebsiteInSearchTableViewCell
                
                cell.keyWord = self.textField.text
                cell.website = website
                
                if selectedWebsites.contains(where: { return $0.id == website.id }) {
                    cell.isChosen = true
                } else {
                    cell.isChosen = false
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableView == tableView {
            return 44
        } else {
            if textField.text?.isEmpty == true {
                return UI.ScreenHeight - 64
            } else {
                return 55
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.tableView == tableView {
            return characters
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if title == UITableViewIndexSearch {
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            return NSNotFound
        } else {
            return index - 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.tableView == tableView {
            
            let label = UILabel()
            label.text = characters[section + 1]
            label.frame = CGRect(x: 8, y: 0, width: 200, height: 20)
            label.font = UIFont.systemFont(ofSize: 12)
            let view = UIView()
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            
            return view
            
        } else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView == tableView {
            return 20
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.tableView == tableView {
            
            let website = websitesArray[indexPath.section][indexPath.row]
            
            let cell = self.tableView.cellForRow(at: indexPath) as! MKChooseWebsiteTableViewCell
            if selectedWebsites.contains(where: { return $0.id == website.id }) {
                
                let selectedWebsite = selectedWebsites.filter { return $0.id == website.id }.first
                let _ = selectedWebsites.removeObject(selectedWebsite!)
                cell.isChosen = false
            } else {
                
                selectedWebsites.insert(website, at: 0)
                cell.isChosen = true
            }
            updateUI()
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
        } else {
         
            if textField.text?.isEmpty == true {
                
                blurEffectView.isHidden = true
                textField.resignFirstResponder()
                
            } else {
                
                let website = searchResultWebsites[indexPath.row]
                
                if selectedWebsites.contains(where: { return $0.id == website.id }) {
                    
                } else {
                    
                    self.selectedWebsites.insert(website, at: 0)
                }
                
                blurEffectView.isHidden = true
                
                textField.text = nil
                textField.resignFirstResponder()
                
                updateUI()
                self.searchTableView.backgroundColor = UIColor.clear
                self.searchTableView.reloadData()
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ChooseWebsiteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.MKChooseLogoCollectionViewCell, for: indexPath) as! MKChooseLogoCollectionViewCell
        
        cell.website = selectedWebsites[indexPath.item]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedWebsites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 36, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedWebsites.remove(at: indexPath.item)
        self.updateUI()
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
}


// MARK: - UITextFieldDelegate

extension ChooseWebsiteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if selectedWebsites.count == 0 {
            self.textField.frame            = CGRect(x: 15, y: 0, width: UI.ScreenWidth - 34, height: 54)
            self.searchImageView.isHidden   = true
        }
        blurEffectView.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace = strcmp(char, "\\b")
        
        if isBackSpace == -92 && textField.text?.isEmpty == true {
            blurEffectView.isHidden = true
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUI()
    }
    
    func textFieldEditingChanged(_ textFeild: UITextField) {
        
        self.searchTableView.backgroundColor = UIColor.clear
        if textField.text?.isEmpty != true {
            self.searchTableView.backgroundColor = UIColor.white
        }
        if let text = textField.text {
            self.searchResultWebsites = self.websites.filter({ return $0.name.contains(text) || $0.url!.host!.contains(text) })
        }
        
        self.searchTableView.reloadData()
    }
}


// MARK: - UIScrollViewDelegate

extension ChooseWebsiteViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.searchTableView {
            
            self.textField.resignFirstResponder()
        }
    }
}
