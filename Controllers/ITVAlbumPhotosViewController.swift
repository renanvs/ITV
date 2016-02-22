//
//  ITVAlbumPhotosViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/13/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVAlbumPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView : UICollectionView!
    var albumModel : AlbumEntity?
    var list = [PhotoEntity]()
    var hasImageDisplaying = false
    var selectMenuButtonGesture : UITapGestureRecognizer?
    var currentIndexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albuns"
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("parsedAlbumPhotosSuccess:"), name: "parsedAlbumPhotosSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("entityUpdated"), name: "entityUpdated", object: nil)
        
        selectMenuButtonGesture = UITapGestureRecognizer(target: self, action: "menuPress:")
        selectMenuButtonGesture!.enabled = false
        selectMenuButtonGesture!.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(selectMenuButtonGesture!)
        
        let selectPlayButtonGesture = UITapGestureRecognizer(target: self, action: "playPress:")
        selectPlayButtonGesture.enabled = true
        selectPlayButtonGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(selectPlayButtonGesture)
        
    }
    
    func menuPress(event : UITapGestureRecognizer){
        if hasImageDisplaying == true{
            removeDisplayedImage()
        }
    }
    
    override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
        
        // The magic is in the next two lines
        if context.nextFocusedView is UICollectionViewCell{
            let cell: UICollectionViewCell = context.nextFocusedView as! UICollectionViewCell
            let indexPath: NSIndexPath? = photosCollectionView.indexPathForCell(cell)
            currentIndexPath = indexPath!
            print(indexPath)
        }
        
        
        // <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}
        
        return true
    }
    
    func playPress(event : UITapGestureRecognizer){
        if hasImageDisplaying == true{
            return
        }
        
        let indexPath =  currentIndexPath!
        
        let photoModel = list[indexPath.row]
        print("\(photoModel.name!) - id: \(photoModel.identifier)")
        
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
        
        photosCollectionView.reloadData()
        
        ds.synchronize()
        
        ITVCoreData.saveContext()
    }

    
    func entityUpdated(){
        list = PhotoEntity.getAllWithAlbum(albumModel!)
        photosCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        //currentIndexPath = indexPath
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
        imageView.image = UIImage(named: "1.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let favImageView = cell.contentView.viewWithUniqueTag(3) as! UIImageView
        
        if photoModel.favorited?.boolValue == true{
            favImageView.alpha = 1
        }else{
            favImageView.alpha = 0
        }
        
        let titleLabel = cell.contentView.viewWithUniqueTag(2) as! UILabel
        
        titleLabel.text = photoModel.name
        
        //        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
        //
        //            let data = NSData(contentsOfURL: NSURL(string: photoModel.remotePhotoUrl!)!)
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
            displayImageInScreen(photoModel.identifier!)
        }
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
            }
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
        
        let imageView = UIImageView(image: UIImage.ITVgetLocalImageWithIdentifier(identifier))
        imageView.frame = CGRectMake(0, 0, 1300, 800)
        imageView.contentMode = .ScaleAspectFit
        //imageView.adjustsImageWhenAncestorFocused = true
        
        container.addSubview(imageView)
        imageView.centerInSuperview()
        self.view.addSubview(container)
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            container.alpha = 1
            }) { (value) -> Void in
                
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func parsedAlbumPhotosSuccess(not : NSNotification){
        list = not.object as! [PhotoEntity]
        photosCollectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        ITVFacebookService.requestPhotoFromAlbumIdentifier(albumModel!.identifier!)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    //        return 5
    //    }
    //
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    //        return 10
    //    }
    
}
