//
//  ITVLoginViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVLoginViewController: UIViewController{
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestCompleted", name: ITVStatics.NOTIFICATION_finishedGetProfileInfo, object: nil)
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
