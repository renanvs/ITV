//
//  ITVUtils.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVUtils: NSObject {
    class func getStoryBoard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func getControllerBaseOnFacebookStatus() -> UIViewController{
        
        let sb = ITVUtils.getStoryBoard()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let tabcontroller = ITVTabBarController()
            
            let currentVC = sb.instantiateViewControllerWithIdentifier("ITVAlbumsViewController")
            let navigationVc = UINavigationController(rootViewController: currentVC)
            
            var controllers = [UIViewController]()
            controllers.append(navigationVc)
            
            if PhotoEntity.getAllFavorites().count > 0{
                let favoriteVC = sb.instantiateViewControllerWithIdentifier("ITVFavoritesViewController") as! ITVFavoritesViewController
                controllers.append(favoriteVC)
            }
            
            let configVC = sb.instantiateViewControllerWithIdentifier("ITVSplitViewController")
            controllers.append(configVC)
            
            tabcontroller.viewControllers = controllers
            return tabcontroller
        }else{
            return sb.instantiateViewControllerWithIdentifier("ITVLoginViewController")
        }
    }
}
