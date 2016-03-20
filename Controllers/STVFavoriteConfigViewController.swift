//
//  STVFavoriteConfigViewController.swift
//  InstaTV
//
//  Created by renanvs on 3/7/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVFavoriteConfigViewController: STVBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var slideTime : UITextField!
    
    @IBAction func cleanFavorites(){
        
        STVTracker.trackEvent("FavoritesConfigScreen", action: "CleanPressed", label: nil)
        
        let ds = NSUbiquitousKeyValueStore.defaultStore()
        let keys = (ds.dictionaryRepresentation as NSDictionary).allKeys
        for key in keys as! [String]{
            if NSString.isStringWithNumeric(key) == true{
                ds.removeObjectForKey(key)
                let photoEntity = PhotoEntity.getByIndentifier(key)
                if let pe = photoEntity {
                    pe.favorited = NSNumber(bool: false)
                }
            }
        }
        ds.synchronize()
        STVCoreData.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideTime.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = NSUbiquitousKeyValueStore.defaultStore().doubleForKey(STVStatics.DEFINE_SlideTime)

        setValueForSlide(value)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != nil{
            let value = (textField.text! as NSString).doubleValue
            
            setValueForSlide(value)
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text != nil{
            let value = (textField.text! as NSString).doubleValue
            
            setValueForSlide(value)
        }
        return true
    }
    
    
    private func setValueForSlide(var value : Double){
        
        if value < 1 {
            value = 1
        }
        
        if value > 60{
            value = 60
        }
        
        NSUbiquitousKeyValueStore.defaultStore().setDouble(value, forKey: STVStatics.DEFINE_SlideTime)
        NSUbiquitousKeyValueStore.defaultStore().synchronize()
        NSUserDefaults.standardUserDefaults().setDouble(value, forKey: STVStatics.DEFINE_SlideTime)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        STVTracker.trackEvent("FavoritesConfigScreen", action: "SetValueForSlide", label: String(format: "%.0f", value))
        
        slideTime.text = String(format: "%.0f", value)
    }
    
    override func trackScreen() {
        STVTracker.trackScreen("FavoritesConfig")
    }

}
