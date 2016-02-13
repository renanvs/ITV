//
//  ITVProfileViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVProfileViewController: UIViewController {
    
    @IBOutlet weak var imageProfile : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func viewDidAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.redColor()
        let user = ITVFacebookService.getUser() as! ITVFacebookUser
        let requestModel = DownloadRequestModel(identifierString: "", andRemoteUrl: user.pictureURI)
        DownloadService.downloadWithRequestModel(requestModel) { (response) -> Void in
            self.imageProfile.image = UIImage.localPartialPath(response.localUrl)
            print("sdfsd")
        }
    }
}
