//
//  STVTracker.swift
//  SocialPhotoTV
//
//  Created by renan silva on 3/9/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class STVTracker: NSObject {
    
    class func startTrackService(){
            GATracker.setup("")
            Flurry.startSession("");
//            Fabric.with([Crashlytics.self])
//            GATracker.setup("UA-74946012-2")
//            Flurry.startSession("V48Z9RZV5J5GDDB2M3KD");
        
        
    }
    
    class func trackEvent(event : String, action : String, label : String?){
        GATracker.sharedInstance.event(event, action: action, label: label, customParameters: nil)
        
        var atr : [String:String] = ["action" : action]
        if (!String.isEmptyStr(label)){
            atr["label"] = label!
        }
        
        Flurry.logEvent(event, withParameters: atr)
        
        Answers.logCustomEventWithName(event, customAttributes: atr)
    }
    
    class func trackScreen(value : String){
        GATracker.sharedInstance.screenView("\(value)_Screen", customParameters: nil)
        
        Answers.logContentViewWithName("\(value)_Screen", contentType: nil, contentId: nil, customAttributes: nil)
        
    }

}
