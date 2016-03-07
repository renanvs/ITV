//
//  ITVBaseViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/28/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVBaseViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        addMainObservers()
    }
    
    func addMainObservers(){
        addObservers()
    }
    
    func addObservers(){}
    
    override func viewWillDisappear(animated: Bool) {
        removeAllNotificationObservers()
    }
}
