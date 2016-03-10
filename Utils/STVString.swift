//
//  STVStrings.swift
//  InstaTV
//
//  Created by renan silva on 2/28/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVString : NSObject{
    class func Lang(value : String) -> String{
        return NSLocalizedString(value, comment: "")
    }
    
    static let Albums_Title = "Albums_Title"
    static let Favorites_Title = "Favorites_Title"
    
    static let Albums__FirstRun_Message = "Albums__FirstRun_Message"
    static let PhotoAlbums__FirstRun_Message = "PhotoAlbums__FirstRun_Message"
    static let PhotoAlbumsFavorite__FirstRun_Message = "PhotoAlbumsFavorite__FirstRun_Message"
    static let Favorites__FirstRun_Message = "Favorites__FirstRun_Message"
    
}