//
//  PhotoEntity.swift
//  InstaTV
//
//  Created by renan silva on 2/14/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoEntity)
class PhotoEntity: NSManagedObject {

    class func newEntity()->PhotoEntity{
        let entity = NSEntityDescription.insertNewObjectForEntityForName("PhotoEntity", inManagedObjectContext: CCCoreData.ctx())
        return entity as! PhotoEntity
    }
    
    class func getAllWithAlbum(album : AlbumEntity)->[PhotoEntity]{
        let fetch = NSFetchRequest(entityName: "PhotoEntity")
        let predicate = NSPredicate(format: "album.identifier == %@", album.identifier!)
        fetch.predicate = predicate
        
        do{
            let list = try CCCoreData.ctx().executeFetchRequest(fetch)
            return list as! [PhotoEntity]
        }catch{
            return [PhotoEntity]()
        }
        
    }
    
    class func getByIndentifier(identifier : String) -> PhotoEntity?{
        let fetch = NSFetchRequest(entityName: "PhotoEntity")
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        fetch.predicate = predicate
        
        do{
            let list = try CCCoreData.ctx().executeFetchRequest(fetch) as! [PhotoEntity]
            return list.first
        }catch{
            return nil
        }
    }

}
