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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("parsedAlbumPhotosSuccess:"), name: "parsedAlbumPhotosSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("entityUpdated"), name: "entityUpdated", object: nil)
    }
    
    func entityUpdated(){
        list = PhotoEntity.getAllWithAlbum(albumModel!)
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
        
        let favImageView = cell.contentView.viewWithUniqueTag(3) as! UIImageView
        
        if photoModel.favorited?.boolValue == true{
            favImageView.alpha = 1
        }else{
            favImageView.alpha = 0
        }
        
        let titleLabel = cell.contentView.viewWithUniqueTag(2) as! UILabel
        
        titleLabel.text = photoModel.name

        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            
            let data = NSData(contentsOfURL: NSURL(string: photoModel.remotePhotoUrl!)!)
            var image : UIImage?
            if let d = data{
                image = UIImage(data: d)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let img = image{
                    
                    
                    if cell.tag == indexPath.row{
                        imageView.image = img
                    }
                    
                }
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoModel = list[indexPath.row]
        print("\(photoModel.name!) - id: \(photoModel.identifier)")
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
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
        
        ds.synchronize()
        
        ITVCoreData.saveContext()
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }

}
