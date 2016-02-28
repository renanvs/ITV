//
//  ITVLoginViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVLoginViewController: ITVBaseViewController{
        
    override func addObservers() {
        addSimpleObserver(ITVStatics.NOTIFICATION_finishedGetProfileInfo, selectorName:"requestCompleted")
    }
    
    func requestCompleted(){
        let vc = ITVUtils.getControllerBaseOnFacebookStatus()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let view = self.view.viewWithTag(1)!
        view.clearColor()
        let button = ITVFacebookService.sharedInstance().generateLoginButtonWithCenterView(view)
        view.addSubview(button)
    }
}
