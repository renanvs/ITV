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
    
    class func showHelpAlbumMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("ITVFirstRunAlbumMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: ITVString.Lang(ITVString.Albums__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ITVFirstRunAlbumMessage")
        }
        
        return value
    }
    
    class func showHelpPhotoAlbumMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("ITVFirstRunPhotoAlbumMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: ITVString.Lang(ITVString.PhotoAlbums__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ITVFirstRunPhotoAlbumMessage")
        }
        
        return value
    }
    
    class func showHelpPhotoAlbumFavorite() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("ITVFirstRunPhotoAlbumFavoriteMessage") == nil ? true : false
        if value == true{
        let currentController = Utils.getCurrentWindow().rootViewController;
        let alert = UIAlertController(title: "Social Photo TV", message: ITVString.Lang(ITVString.PhotoAlbumsFavorite__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        currentController?.presentViewController(alert, animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ITVFirstRunPhotoAlbumFavoriteMessage")
        }
    
        return value
    }
    
    class func showHelpFavoritesMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("ITVFirstRunFavoritesMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: ITVString.Lang(ITVString.Favorites__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ITVFirstRunFavoritesMessage")
        }
        
        return value
    }

}
