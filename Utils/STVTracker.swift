//
//  STVTracker.swift
//  SocialPhotoTV
//
//  Created by renan silva on 3/9/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVTracker: NSObject {
    
    class func startTrackService(){
        GATracker.setup("UA-42084813-1")
    }
    
    class func trackEvent(event : String, action : String, label : String?){
        GATracker.sharedInstance.event(event, action: action, label: label, customParameters: nil)
    }

}
