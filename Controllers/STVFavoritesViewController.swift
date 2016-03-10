//
//  STVFavoritesViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/16/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVFavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView : UICollectionView!
    var list = [PhotoEntity]()
    var currentIndexPath : NSIndexPath?
    
    //MARK: Native Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = STVString.Lang(STVString.Favorites_Title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = STVString.Lang(STVString.Favorites_Title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STVUtils.showHelpFavoritesMessage()
        let selectPlayButtonGesture = UITapGestureRecognizer(target: self, action: "playPress:")
        selectPlayButtonGesture.enabled = true
        selectPlayButtonGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(selectPlayButtonGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        list = PhotoEntity.getAllFavorites()
        photosCollectionView.reloadData()
    }
    
    override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
        
        if context.nextFocusedView is UICollectionViewCell{
            let cell: UICollectionViewCell = context.nextFocusedView as! UICollectionViewCell
            let indexPath: NSIndexPath? = photosCollectionView.indexPathForCell(cell)
            currentIndexPath = indexPath!
            print(indexPath)
        }
        
        return true
    }
    
    //MARK: Internal Methods
    
    func playPress(tap : UITapGestureRecognizer){
        let photosVC = STVUtils.getStoryBoard().instantiateViewControllerWithIdentifier("STVPhotosPageViewController") as! STVPhotosPageViewController
        photosVC.photosList = list
        let photoModel = list[currentIndexPath!.row]
        photosVC.currentPhotoEntity = photoModel
        self.presentViewController(photosVC, animated: true, completion: nil)
    }
    
    //MARK: CollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumPhotoCell", forIndexPath: indexPath)
        cell.tag = indexPath.row
        cell.contentView
        let photoModel = list[indexPath.row]
        let imageView = cell.contentView.viewWithUniqueTag(1) as! UIImageView
        
        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = nil
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.image = UIImage.DefaultImage()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        if DownloadService.existThisFile(photoModel.identifier) == true{
            if cell.tag == indexPath.row{
                imageView.image = UIImage.STVgetLocalImageWithIdentifier(photoModel.identifier)
            }
        }else{
            let model = DownloadRequestModel(identifierString: photoModel.identifier, andRemoteUrl: photoModel.remotePhotoUrl)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                if cell.tag == indexPath.row{
                    imageView.image = UIImage.STVgetLocalImageWithIdentifier(photoModel.identifier)
                }
                }, blockError: nil)
        }
        
        if currentIndexPath == nil{
            currentIndexPath = indexPath
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoModel = list[indexPath.row]
        
        let photosVC = STVUtils.getStoryBoard().instantiateViewControllerWithIdentifier("STVPhotosPageViewController") as! STVPhotosPageViewController
        photosVC.photosList = list
        photosVC.currentPhotoEntity = photoModel
        self.presentViewController(photosVC, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
}