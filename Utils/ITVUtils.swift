//
//  ITVUtils.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVUtils: NSObject {

}

extension UIImage{
    class func ITVgetLocalImageWithIdentifier(identifier : String?) -> UIImage?{
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
}
