//
//  ITVLoginViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVLoginViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestCompleted", name: "finishedGetProfileInfo", object: nil)
    }
    
    func requestCompleted(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("ITVProfileViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        //let loginButton = fbsdkloggin
        
        let button = ITVFacebookService.sharedInstance().generateLoginButton()
        self.view.addSubview(button)
        
    }
}
