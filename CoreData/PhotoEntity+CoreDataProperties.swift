//
//  PhotoEntity+CoreDataProperties.swift
//  SocialPhotoTV
//
//  Created by renanvs on 5/2/16.
//  Copyright © 2016 mwg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhotoEntity {

    @NSManaged var favorited: NSNumber?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var remotePhotoUrl: String?
    @NSManaged var album: AlbumEntity?

}
