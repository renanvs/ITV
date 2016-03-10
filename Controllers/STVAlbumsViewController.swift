//
//  STVProfileViewController.swift
//  InstaTV
//
//  Created by renanvs on 2/11/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVAlbumsViewController: STVBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var albumCollectionView : UICollectionView!
    var list = [AlbumEntity]()

    //MARK: Base Class
    
    override func addObservers() {
        addSimpleObserver(STVStatics.NOTIFICATION_parsedAlbunsSuccess, selectorName:"parsedAlbunsSuccess")
    }
    
    //MARK: Native Class
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STVUtils.showHelpAlbumMessage()
    }
    
    override func viewDidAppear(animated: Bool) {
        STVFacebookService.requestAlbuns()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = STVString.Lang(STVString.Albums_Title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = STVString.Lang(STVString.Albums_Title)
    }
    
    //MARK: CollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumCell", forIndexPath: indexPath)
        cell.tag = indexPath.row
        cell.contentView
        let albumModel = list[indexPath.row]
        let imageView = cell.contentView.viewWithUniqueTag(1) as! UIImageView

        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = nil
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.image = UIImage.DefaultImage()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let titleLabel = cell.contentView.viewWithUniqueTag(2) as! UILabel
        let countLabel = cell.contentView.viewWithUniqueTag(3) as! UILabel
        
        titleLabel.text = albumModel.name
        countLabel.text = albumModel.photoCount!.stringValue
        
        if DownloadService.existThisFile(albumModel.identifier) == true{
            if cell.tag == indexPath.row{
                imageView.image = UIImage.STVgetLocalImageWithIdentifier(albumModel.identifier)
            }
        }else{
            let model = DownloadRequestModel(identifierString: albumModel.identifier, andRemoteUrl: albumModel.remoteCoverUrl)
            DownloadService.downloadWithRequestModel(model, blockSuccess: { (response) -> Void in
                if cell.tag == indexPath.row{
                    imageView.image = UIImage.STVgetLocalImageWithIdentifier(albumModel.identifier)
                }
                }, blockError: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let albumModel = list[indexPath.row]
        
        let vc = STVUtils.getStoryBoard().instantiateViewControllerWithIdentifier("STVAlbumPhotosViewController") as! STVAlbumPhotosViewController
        vc.albumModel = albumModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    //MARK: Internal Methods
    
    func parsedAlbunsSuccess(){
        list = STVFacebookService.getAlbuns() as! [AlbumEntity]
        albumCollectionView.reloadData()
    }
    
}
