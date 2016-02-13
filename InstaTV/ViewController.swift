//
//  ViewController.swift
//  use_frameworks!
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, FBSDKDeviceLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //request()
    }
    
    func deviceLoginButtonDidLogIn(button: FBSDKDeviceLoginButton) {
        print("sdfsdf")
    }
    
    func deviceLoginButtonDidFail(button: FBSDKDeviceLoginButton, error: NSError) {
        
    }
    
    func deviceLoginButtonDidCancel(button: FBSDKDeviceLoginButton) {
        
    }
    
    func deviceLoginButtonDidLogOut(button: FBSDKDeviceLoginButton) {
        
    }
    
    func requestProfile(){
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            FBSDKGraphRequest(graphPath: "me?fields=id,name,email,bio,first_name,last_name,work", parameters: nil, HTTPMethod: "GET").startWithCompletionHandler({ (connection, obj, error) -> Void in
                
                print("x")
                
            })
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //let loginButton = fbsdkloggin
        
        let button = FBSDKDeviceLoginButton(frame: CGRectZero)
        button.readPermissions = ["email"]
        button.center = self.view.center
        button.delegate = self
        self.view.addSubview(button)
        requestProfile()
    }

    func request(){
        defaultGetWithUrl("https://api.instagram.com/oauth/authorize/?client_id=288a8978829e4557a053f9724b53b2b0&redirect_uri=http://www.mwg.art.br/&response_type=code", successBlock: { (result) -> Void in
            print("a")
            }) { (error) -> Void in
                print("b")
        }
    }
    
    func defaultGetWithUrl(url:String, successBlock:((result: AnyObject) -> Void)?,errorBlock:((error: NSError) -> Void)?){
        let operationManager = AFHTTPSessionManager()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        operationManager.requestSerializer = AFJSONRequestSerializer(writingOptions: .PrettyPrinted)
        operationManager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "application/json", "text/json") as? Set<String>
        
        operationManager.GET(url, parameters: nil, progress: nil, success: { (sessionData, obj) -> Void in
            
            print("a")
            
            }) { (sessionData, error) -> Void in
                if let e = errorBlock{
                    e(error: error)
                }
        }
        
        
    }

    
}

