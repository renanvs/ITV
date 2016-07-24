//
//  STVUtils.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVUtils: NSObject {
    class func existFavoriteInNavController() -> Bool{
        if Utils.getRootController().isKindOfClass(STVTabBarController){
            let tab = Utils.getRootController() as! STVTabBarController
            for controller in tab.viewControllers!{
                if controller.isKindOfClass(STVFavoritesViewController){
                    return true
                }
            }
        }
        
        return false
    }
    
    class func getStoryBoard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func getControllerBaseOnFacebookStatus() -> UIViewController{
        
        let sb = STVUtils.getStoryBoard()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let tabcontroller = STVTabBarController()
            
            let currentVC = sb.instantiateViewControllerWithIdentifier("STVAlbumsViewController")
            let navigationVc = UINavigationController(rootViewController: currentVC)
            
            var controllers = [UIViewController]()
            controllers.append(navigationVc)
            
            if PhotoEntity.getAllFavorites().count > 0{
                let favoriteVC = sb.instantiateViewControllerWithIdentifier("STVFavoritesViewController") as! STVFavoritesViewController
                controllers.append(favoriteVC)
            }
            
            let configVC = sb.instantiateViewControllerWithIdentifier("STVSplitViewController")
            controllers.append(configVC)
            
            tabcontroller.viewControllers = controllers
            return tabcontroller
        }else{
            return sb.instantiateViewControllerWithIdentifier("STVLoginViewController")
        }
    }
    
    class func showHelpAlbumMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("STVFirstRunAlbumMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: STVString.Lang(STVString.Albums__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "STVFirstRunAlbumMessage")
        }
        
        return value
    }
    
    class func showHelpPhotoAlbumMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("STVFirstRunPhotoAlbumMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: STVString.Lang(STVString.PhotoAlbums__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "STVFirstRunPhotoAlbumMessage")
        }
        
        return value
    }
    
    class func showHelpPhotoAlbumFavorite() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("STVFirstRunPhotoAlbumFavoriteMessage") == nil ? true : false
        if value == true{
        let currentController = Utils.getCurrentWindow().rootViewController;
        let alert = UIAlertController(title: "Social Photo TV", message: STVString.Lang(STVString.PhotoAlbumsFavorite__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        currentController?.presentViewController(alert, animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "STVFirstRunPhotoAlbumFavoriteMessage")
        }
    
        return value
    }
    
    class func showHelpFavoritesMessage() -> Bool{
        let value = NSUserDefaults.standardUserDefaults().objectForKey("STVFirstRunFavoritesMessage") == nil ? true : false
        if value == true{
            let currentController = Utils.getCurrentWindow().rootViewController;
            let alert = UIAlertController(title: "Social Photo TV", message: STVString.Lang(STVString.Favorites__FirstRun_Message), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            currentController?.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "STVFirstRunFavoritesMessage")
        }
        
        return value
    }
    
    class func getSlideTime() -> Double{
        let obj = NSUbiquitousKeyValueStore.defaultStore().objectForKey(STVStatics.DEFINE_SlideTime)
        
        var value : Double = 3
        
        if obj != nil{
            value = obj!.doubleValue
        }
        
        if value < 1 {
            value = 1
        }
        
        if value > 60{
            value = 60
        }
        
        NSUbiquitousKeyValueStore.defaultStore().setDouble(value, forKey: STVStatics.DEFINE_SlideTime)
        
        return value
    }

}
