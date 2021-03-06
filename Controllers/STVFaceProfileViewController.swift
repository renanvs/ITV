//
//  STVFaceProfileViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/22/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVFaceProfileViewController: STVBaseViewController {
    
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var mailLabel : UILabel!
    @IBOutlet var facebookContainer : UIView!

    
    override func trackScreen() {
        STVTracker.trackScreen("Screen")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let button = STVFacebookService.sharedInstance().generateLoginButtonWithCenterView(facebookContainer)
        facebookContainer.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let facebookUser = STVFacebookService.getUser() as! STVFacebookUser
        
        nameLabel.text = facebookUser.name?.uppercaseString
        mailLabel.text = facebookUser.email.uppercaseString
        
        STVTracker.trackEvent("ProfileScreen", action: "Info", label: "name: \(facebookUser.name!) | email: \(facebookUser.email) | image: \(facebookUser.pictureURI)")
        
        if DownloadService.existThisFile(facebookUser.identifier){
            profileImageView.image = UIImage.STVgetLocalImageWithIdentifier(facebookUser.identifier)
        }else{
            let model = DownloadRequestModel(identifierString: facebookUser.identifier, andRemoteUrl: facebookUser.pictureURI!)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                self.profileImageView.image = UIImage.STVgetLocalImageWithIdentifier(facebookUser.identifier)
                }, blockError: { () -> Void in
                    
            })
        }
        
        profileImageView.layer.cornerRadius = profileImageView.widthSize()/2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 10
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
}
