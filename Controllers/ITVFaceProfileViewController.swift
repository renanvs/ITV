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
    }
    
}
