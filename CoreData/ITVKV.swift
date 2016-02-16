//
//  ITVKV.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVKV: NSObject {
    static let sharedInstance = ITVKV()

    override init(){
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeKV:"), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keysUpdated"), name: "keysUpdated", object: nil)
        
        let store = NSUbiquitousKeyValueStore.defaultStore()
        store.synchronize()
    }
    
    func keysUpdated(){
        let list = PhotoEntity.getAll()
        for photoEntity in list{
            
            let value = NSUbiquitousKeyValueStore.defaultStore().boolForKey(photoEntity.identifier!);
            if value == true{
                photoEntity.favorited = NSNumber(bool: true)
            }else{
                photoEntity.favorited = NSNumber(bool: false)
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("entityUpdated", object: nil)
    }
    
    func changeKV(notification:NSNotification){
        let userInfo = notification.userInfo as! NSDictionary
        let changeReason = userInfo.objectForKey(NSUbiquitousKeyValueStoreChangeReasonKey)
        
        if changeReason == nil{
            return
        }
        
        let reaseInt = changeReason!.integerValue
        
        if ((reaseInt == NSUbiquitousKeyValueStoreServerChange) || (reaseInt == NSUbiquitousKeyValueStoreInitialSyncChange)) {
            
            
            let changedKeys = userInfo.objectForKey(NSUbiquitousKeyValueStoreChangedKeysKey) as! [String]
            
            let store = NSUbiquitousKeyValueStore.defaultStore()
            
            // Search Keys for "bookmarks" Key
            for key in changedKeys {
                if key == "bookmarks" {
                    // Update Data Source
                    //self.bookmarks = [NSMutableArray arrayWithArray:[store objectForKey:key]];
                    print("dsfsdf")
                    
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("keysUpdated", object: nil)
        }
    }
    
}
