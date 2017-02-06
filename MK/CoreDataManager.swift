//
//  CoreDataManager.swift
//  MK
//
//  Created by MK on 2016/10/27.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Constants
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class var instance: CoreDataManager {
        struct Static {
            static let inst: CoreDataManager = CoreDataManager()
        }
        return Static.inst
    }
    
    
    // MARK: - Get Entities
    
    class func getUserEntity() -> MKUserEntity {
        
        let fetchRequest = NSFetchRequest<MKUserEntity>(entityName: "MKUserEntity")
        
        let results = (try! instance.appDelegate.managedObjectContext.fetch(fetchRequest))
        
        if results.isEmpty {
            
            let userEntity = insertNewUser()
            
            userEntity.fontSize = 100
            
            return userEntity
        }
        
        return results.first!
    }
    
    class func getWebsitesBy(status: String) -> [MKWebsiteEntity] {
        let fetchRequest = NSFetchRequest<MKWebsiteEntity>(entityName: CoreDataConstant.MKWebsiteEntityKey)
        
        // find commodity throught pk
        fetchRequest.predicate = NSPredicate(format: "status == %@", status)
        
        let results = (try! instance.appDelegate.managedObjectContext.fetch(fetchRequest))
        
        // Handle errors here
        
        return results
    }
    
    class func getWebsites() -> [MKWebsiteEntity]  {
        
        let fetchRequest = NSFetchRequest<MKWebsiteEntity>(entityName: CoreDataConstant.MKWebsiteEntityKey)
        
        let results = (try! instance.appDelegate.managedObjectContext.fetch(fetchRequest))
        
        // Handle errors here
        
        return results
    }
    
    class func getCollectionItems() -> [MKCollectionEntity] {
        
        let fetchRequest = NSFetchRequest<MKCollectionEntity>(entityName: CoreDataConstant.MKCollectionEntityKey)
        
        let results = (try! instance.appDelegate.managedObjectContext.fetch(fetchRequest))
        
        // Handle errors here
        
        return results
    }
    
    class func insertNewWebsite() -> MKWebsiteEntity {
        
        return NSEntityDescription.insertNewObject(forEntityName: "MKWebsiteEntity", into: instance.appDelegate.managedObjectContext) as! MKWebsiteEntity
    }
    
    class func inserNewCollectionItemEntity() -> MKCollectionEntity {
        return NSEntityDescription.insertNewObject(forEntityName: "MKCollectionEntity", into: instance.appDelegate.managedObjectContext) as! MKCollectionEntity
    }
    
    class func insertNewUser() -> MKUserEntity {
        
        return NSEntityDescription.insertNewObject(forEntityName: "MKUserEntity", into: instance.appDelegate.managedObjectContext) as! MKUserEntity
    }
    
    class func deleteCollectionItem(id: String) {
        
        let fetchRequest = NSFetchRequest<MKCollectionEntity>(entityName: CoreDataConstant.MKCollectionEntityKey)
        
        // find commodity throught pk
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = (try! instance.appDelegate.managedObjectContext.fetch(fetchRequest))
        
        instance.appDelegate.managedObjectContext.delete(results.first!)
        
    }
    
    class func saveContext() {
        
        instance.appDelegate.saveContext()
    }
}
