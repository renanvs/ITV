//
//  ITVProfileViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //@IBOutlet weak var imageProfile : UIImageView!
    @IBOutlet weak var albumCollectionView : UICollectionView!
    var list = [AlbumEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("parsedAlbunsSuccess"), name: "parsedAlbunsSuccess", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumCell", forIndexPath: indexPath)
        cell.tag = indexPath.row
        cell.contentView
        let albumModel = list[indexPath.row]
        let imageView = cell.contentView.viewWithUniqueTag(1) as! UIImageView

        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = nil
        //imageView.clipsToBounds = true
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.image = UIImage(named: "1.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let titleLabel = cell.contentView.viewWithUniqueTag(2) as! UILabel
        let countLabel = cell.contentView.viewWithUniqueTag(3) as! UILabel
        
        titleLabel.text = albumModel.name
        countLabel.text = albumModel.photoCount!.stringValue
        
        if DownloadService.existThisFile(albumModel.identifier) == true{
            if cell.tag == indexPath.row{
                imageView.image = UIImage.ITVgetLocalImageWithIdentifier(albumModel.identifier)
            }
        }else{
            let model = DownloadRequestModel(identifierString: albumModel.identifier, andRemoteUrl: albumModel.remoteCoverUrl)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                if cell.tag == indexPath.row{
                    imageView.image = UIImage.ITVgetLocalImageWithIdentifier(albumModel.identifier)
                }
                }, blockError: nil)
        }
        
        
        
//        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
//            
//            //let identifier = albumModel.albumId
//            let data = NSData(contentsOfURL: NSURL(string: albumModel.remoteCoverUrl!)!)
//            var image : UIImage?
//            if let d = data{
//                image = UIImage(data: d)
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                if let img = image{
//                    
//                    
//                    if cell.tag == indexPath.row{
//                        imageView.image = img
//                    }
//                    
//                }
//            })
//        }

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let albumModel = list[indexPath.row]
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("ITVAlbumPhotosViewController") as! ITVAlbumPhotosViewController
        vc.albumModel = albumModel
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("\(albumModel.name!)")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if list.count > 0{
//            return 5
//        }
        
        return list.count
    }
    
    func parsedAlbunsSuccess(){
        list = ITVFacebookService.getAlbuns() as! [AlbumEntity]
        albumCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        let user = ITVFacebookService.getUser() as! ITVFacebookUser
        let requestModel = DownloadRequestModel(identifierString: "", andRemoteUrl: user.pictureURI)
        DownloadService.downloadWithRequestModel(requestModel) { (response) -> Void in
            //self.imageProfile.image = UIImage.localPartialPath(response.localUrl)
            print("sdfsd")
        }
        
        ITVFacebookService.requestAlbuns()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
//        if let prev = context.previouslyFocusedView as? UICollectionViewCell{
//            let image = prev.contentView.viewWithUniqueTag(1) as! UIImageView
//            //image.adjustsImageWhenAncestorFocused = true
//            image.transform = CGAffineTransformMakeScale(1, 1)
//        }
//        
//        
//        if let next = context.nextFocusedView as? UICollectionViewCell{
//            let image2 = next.contentView.viewWithUniqueTag(1) as! UIImageView
//            //image2.adjustsImageWhenAncestorFocused = true
//            image2.transform = CGAffineTransformMakeScale(1.1, 1.1)
//        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Albuns"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Albuns"
    }
}
