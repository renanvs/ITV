//
//  ITVSingleFullPhotoViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/21/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVSingleFullPhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView : UIImageView!
    var photoEntity : PhotoEntity!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        photoImageView.backgroundColor = UIColor.blackColor()
        
        if DownloadService.existThisFile(photoEntity.identifier) == true{
            photoImageView.image = UIImage.ITVgetLocalImageWithIdentifier(photoEntity.identifier)
            
        }else{
            let model = DownloadRequestModel(identifierString: photoEntity.identifier, andRemoteUrl: photoEntity.remotePhotoUrl)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                self.photoImageView.image = UIImage.ITVgetLocalImageWithIdentifier(self.photoEntity.identifier)
                }, blockError: nil)
        }
    }
}
