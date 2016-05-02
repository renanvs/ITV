//
//  STVAlbumPhotosViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/13/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVAlbumPhotosViewController: STVBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView : UICollectionView!
    var albumModel : AlbumEntity?
    var list = [PhotoEntity]()
    var hasImageDisplaying = false
    var selectMenuButtonGesture : UITapGestureRecognizer?
    var currentIndexPath : NSIndexPath?
    
    
    //MARK: Base Class
    override func addObservers() {
        addSimpleObserver(STVStatics.NOTIFICATION_parsedAlbumPhotosSuccess, selectorName:"parsedAlbumPhotosSuccess:")
        addSimpleObserver(STVStatics.NOTIFICATION_entityUpdated, selectorName: "entityUpdated")
    }
    
    override func trackScreen() {
        STVTracker.trackScreen("AlbumsPhotos")
    }
    
    //MARK: Native Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STVUtils.showHelpPhotoAlbumMessage()
        self.title = STVString.Lang(STVString.Albums_Title)
        self.navigationController?.navigationBarHidden = true
        
        selectMenuButtonGesture = UITapGestureRecognizer(target: self, action: #selector(STVAlbumPhotosViewController.menuPress(_:)))
        selectMenuButtonGesture!.enabled = false
        selectMenuButtonGesture!.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(selectMenuButtonGesture!)
        
        let selectPlayButtonGesture = UITapGestureRecognizer(target: self, action: #selector(STVAlbumPhotosViewController.playPress(_:)))
        selectPlayButtonGesture.enabled = true
        selectPlayButtonGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(selectPlayButtonGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        STVFacebookService.requestPhotoFromAlbumIdentifier(albumModel!.identifier!)
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
    
    func parsedAlbumPhotosSuccess(not : NSNotification){
        list = not.object as! [PhotoEntity]
        photosCollectionView.reloadData()
    }
    
    func removeDisplayedImage(){
        let container = self.view.viewWithTag(10)
        if let ct = container{
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                ct.alpha = 0
                }) { (value) -> Void in
                    ct.removeFromSuperview()
                    self.hasImageDisplaying = false
                    self.selectMenuButtonGesture?.enabled = false
                    self.removeDisplayedImage()
            }
            
        }else{
            return
        }
        
    }
    
    func displayImageInScreen(identifier:String){
        hasImageDisplaying = true
        selectMenuButtonGesture?.enabled = true
        
        let container = UIView(frame: self.view.frame)
        container.backgroundColor = UIColor.blackColor()
        container.backgroundColor?.colorWithAlphaComponent(0.5)
        container.tag = 10
        container.alpha = 0
        
        let imageView = UIImageView(image: UIImage.STVgetLocalImageWithIdentifier(identifier))
        imageView.frame = CGRectMake(0, 0, 1300, 800)
        imageView.contentMode = .ScaleAspectFit
        
        container.addSubview(imageView)
        imageView.centerInSuperview()
        self.view.addSubview(container)
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            container.alpha = 1
            }) { (value) -> Void in
                
        }
    }
    
    func menuPress(event : UITapGestureRecognizer){
        if hasImageDisplaying == true{
            removeDisplayedImage()
        }
    }
    
    func playPress(event : UITapGestureRecognizer){
        if hasImageDisplaying == true{
            return
        }
        
        STVUtils.showHelpPhotoAlbumFavorite()
        
        let indexPath =  currentIndexPath!
        
        let photoModel = list[indexPath.row]
        
        let cell = photosCollectionView.cellForItemAtIndexPath(indexPath)!
        
        let ds = NSUbiquitousKeyValueStore.defaultStore()
        
        let favImageView = cell.contentView.viewWithUniqueTag(3) as! UIImageView
        if photoModel.favorited?.boolValue == false{
            favImageView.alpha = 1
            photoModel.favorited = NSNumber(bool: true)
            
        }else{
            favImageView.alpha = 0
            photoModel.favorited = NSNumber(bool: false)
        }
        
        if photoModel.favorited!.boolValue{
            ds.setBool(true, forKey: photoModel.identifier!)
        }else{
            ds.removeObjectForKey(photoModel.identifier!)
        }
        
        STVTracker.trackEvent("PhotoAlbumScreen", action: "Favorite", label: "\(photoModel.remotePhotoUrl) - \(photoModel.favorited)")
        
        photosCollectionView.reloadData()
        
        ds.synchronize()
        
        STVCoreData.saveContext()
        
        if PhotoEntity.getAllFavorites().count == 1{
            let favoriteVC = STVUtils.getStoryBoard().instantiateViewControllerWithIdentifier("STVFavoritesViewController") as! STVFavoritesViewController
            
            let tabBarController = self.tabBarController!
            tabBarController.viewControllers?.insert(favoriteVC, atIndex: 1)

        }

    }
    
    func entityUpdated(){
        list = PhotoEntity.getAllWithAlbum(albumModel!)
        photosCollectionView.reloadData()
    }
    
    //MARK: CollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
        imageView.image = UIImage.DefaultImage()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let favImageView = cell.contentView.viewWithUniqueTag(3) as! UIImageView
        
        if photoModel.favorited?.boolValue == true{
            favImageView.alpha = 1
        }else{
            favImageView.alpha = 0
        }
        
        let titleLabel = cell.contentView.viewWithUniqueTag(2) as! UILabel
        
        titleLabel.text = photoModel.name
        
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
        
        if hasImageDisplaying == true{
            removeDisplayedImage()
        }else{
            STVTracker.trackEvent("PhotoAlbumScreen", action: "DisplayImage", label: photoModel.remotePhotoUrl)
            displayImageInScreen(photoModel.identifier!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
}
