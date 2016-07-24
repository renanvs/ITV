//
//  AlbumEntity+CoreDataProperties.swift
//  SampleCoreWithCloud
//
//  Created by renanvs on 2/15/16.
//  Copyright © 2016 mwg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AlbumEntity {

    @NSManaged var coverPhotoId: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var photoCount: NSNumber?
    @NSManaged var remoteCoverUrl: String?
    @NSManaged var photos: NSSet?

}
