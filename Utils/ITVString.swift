//
//  ITVStrings.swift
//  InstaTV
//
//  Created by renan silva on 2/28/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVString : NSObject{
    class func Lang(value : String) -> String{
        return NSLocalizedString(value, comment: "")
    }
    
    static let Albums_Title = "Albums_Title"
    static let Favorites_Title = "Favorites_Title"
}