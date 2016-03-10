//
//  STVExtensions.swift
//  InstaTV
//
//  Created by renan silva on 2/28/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVExtensions: NSObject {

}

extension UIImage{
    class func STVgetLocalImageWithIdentifier(identifier : String?) -> UIImage?{
        if identifier == nil{
            return nil
        }
        
        let fullPath = DownloadService.auxFullPath(identifier)
        print("ImagePath: \(fullPath)")
        let data = NSData(contentsOfFile: fullPath)
        var image : UIImage?
        
        if let d = data {
            image = UIImage(data: d)
            return image
        }
        return image
    }
    
    class func DefaultImage() -> UIImage{
        return UIImage(named: "1.jpeg")!
    }
}
