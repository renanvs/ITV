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
        let entity = NSEntityDescription.insertNewObjectForEntityForName("PhotoEntity", inManagedObjectContext: ITVCoreData.ctx())
        return entity as! PhotoEntity
    }
    
    class func getAll()->[PhotoEntity]{
        let fetch = NSFetchRequest(entityName: "PhotoEntity")
        
        do{
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch)
            return list as! [PhotoEntity]
        }catch{
            return [PhotoEntity]()
        }
        
    }
    
    class func getAllFavorites()->[PhotoEntity]{
        let fetch = NSFetchRequest(entityName: "PhotoEntity")
        let predicate = NSPredicate(format: "favorited == %@", NSNumber(bool: true))
        fetch.predicate = predicate
        
        do{
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch)
            return list as! [PhotoEntity]
        }catch{
            return [PhotoEntity]()
        }
    }
    
    class func getAllWithAlbum(album : AlbumEntity)->[PhotoEntity]{
        let fetch = NSFetchRequest(entityName: "PhotoEntity")
        let predicate = NSPredicate(format: "album.identifier == %@", album.identifier!)
        fetch.predicate = predicate
        
        do{
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch)
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
            let list = try ITVCoreData.ctx().executeFetchRequest(fetch) as! [PhotoEntity]
            return list.first
        }catch{
            return nil
        }
    }

}
