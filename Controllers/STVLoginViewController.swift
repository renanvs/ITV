//
//  STVLoginViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVLoginViewController: STVBaseViewController{
        
    override func addObservers() {
        addSimpleObserver(STVStatics.NOTIFICATION_finishedGetProfileInfo, selectorName:"requestCompleted")
        addSimpleObserver("deviceLoginButtonDidLogIn", selectorName: "requestWillStart")
    }
    
    func requestWillStart(){
        let b = self.view.viewWithTag(666)
        if b != nil{
            b!.removeFromSuperview()
        }
    }
    
    func requestCompleted(){
        let vc = STVUtils.getControllerBaseOnFacebookStatus()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let view = self.view.viewWithTag(1)!
        view.clearColor()
        let button = STVFacebookService.sharedInstance().generateLoginButtonWithCenterView(view)
        button.tag = 666
        view.addSubview(button)
    }
    
    override func trackScreen() {
        STVTracker.trackScreen("Login")
    }
}
