//
//  ITVFaceProfileViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/22/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVFaceProfileViewController: UIViewController {
    
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var mailLabel : UILabel!
    @IBOutlet var facebookContainer : UIView!

    override func viewDidAppear(animated: Bool) {
        let button = ITVFacebookService.sharedInstance().generateLoginButtonWithCenterView(facebookContainer)
        facebookContainer.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let facebookUser = ITVFacebookService.getUser() as! ITVFacebookUser
        
        nameLabel.text = facebookUser.name?.uppercaseString
        mailLabel.text = facebookUser.email.uppercaseString
        
        
        if DownloadService.existThisFile(facebookUser.identifier){
            profileImageView.image = UIImage.ITVgetLocalImageWithIdentifier(facebookUser.identifier)
        }else{
            let model = DownloadRequestModel(identifierString: facebookUser.identifier, andRemoteUrl: facebookUser.pictureURI!)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                self.profileImageView.image = UIImage.ITVgetLocalImageWithIdentifier(facebookUser.identifier)
                }, blockError: { () -> Void in
                    
            })
        }
        
        profileImageView.layer.cornerRadius = profileImageView.widthSize()/2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 10
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
