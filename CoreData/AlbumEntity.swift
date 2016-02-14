//
//  AlbumEntity.swift
//  InstaTV
//
//  Created by renan silva on 2/14/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import Foundation
import CoreData

@objc(AlbumEntity)
class AlbumEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func newEntity()->AlbumEntity{
        let entity = NSEntityDescription.insertNewObjectForEntityForName("AlbumEntity", inManagedObjectContext: ITVCoreData.ctx())
        return entity as! AlbumEntity
    }
    
    class func getAll()->[AlbumEntity]{
        let fetch = NSFetchRequest(entityName: "AlbumEntity")
        
        do{
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch)
            return list as! [AlbumEntity]
        }catch{
            return [AlbumEntity]()
        }
        
    }
    
    class func getByIndentifier(identifier : String) -> AlbumEntity?{
        let fetch = NSFetchRequest(entityName: "AlbumEntity")
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        fetch.predicate = predicate
        
        do{
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch) as! [AlbumEntity]
            return list.first
        }catch{
            return nil
        }
    }

}
