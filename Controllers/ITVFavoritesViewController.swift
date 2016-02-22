//
//  ITVFavoritesViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVFavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView : UICollectionView!
    var list = [PhotoEntity]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Favorites"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Favorites"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectPlayButtonGesture = UITapGestureRecognizer(target: self, action: "playPress:")
        selectPlayButtonGesture.enabled = true
        selectPlayButtonGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(selectPlayButtonGesture)
    }
    
    func playPress(tap : UITapGestureRecognizer){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let photosVC = sb.instantiateViewControllerWithIdentifier("ITVPhotosPageViewController") as! ITVPhotosPageViewController
        photosVC.photosList = list
        self.presentViewController(photosVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        list = PhotoEntity.getAllFavorites()
        photosCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumPhotoCell", forIndexPath: indexPath)
        cell.tag = indexPath.row
        cell.contentView
        let photoModel = list[indexPath.row]
        let imageView = cell.contentView.viewWithUniqueTag(1) as! UIImageView
        
        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = nil
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.image = UIImage(named: "1.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        if DownloadService.existThisFile(photoModel.identifier) == true{
            if cell.tag == indexPath.row{
                imageView.image = UIImage.ITVgetLocalImageWithIdentifier(photoModel.identifier)
            }
        }else{
            let model = DownloadRequestModel(identifierString: photoModel.identifier, andRemoteUrl: photoModel.remotePhotoUrl)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                if cell.tag == indexPath.row{
                    imageView.image = UIImage.ITVgetLocalImageWithIdentifier(photoModel.identifier)
                }
                }, blockError: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoModel = list[indexPath.row]
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let photosVC = sb.instantiateViewControllerWithIdentifier("ITVPhotosPageViewController") as! ITVPhotosPageViewController
        photosVC.photosList = list
        photosVC.currentPhotoEntity = photoModel
        self.presentViewController(photosVC, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
}