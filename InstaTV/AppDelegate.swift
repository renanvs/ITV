//
//  AppDelegate.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        ITVCoreData.sharedInstance
//        
//        if AlbumEntity.getAll().count == 0{
//            let entity = AlbumEntity.newEntity()
//            entity.name = "ola album"
//            ITVCoreData.saveContext()
//        }else{
//            let str = (AlbumEntity.getAll().first?.name)!
//            print("\(str)")
//        }
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        var currentVC : UIViewController?
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            currentVC = sb.instantiateViewControllerWithIdentifier("ITVProfileViewController")
        }else{
            currentVC = sb.instantiateViewControllerWithIdentifier("ITVLoginViewController")
        }
        
        let navigationVc = UINavigationController(rootViewController: currentVC!)
        
        self.window?.rootViewController = navigationVc
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

