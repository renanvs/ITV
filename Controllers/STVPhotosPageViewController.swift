	//
//  STVPhotosPageViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/17/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class STVPhotosPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var listControllers = [UIViewController]()
    var photosList = [PhotoEntity]()
    var currentPhotoEntity : PhotoEntity?
    var timer : NSTimer?
    var isPlaying = true
    
    //MARK: Internal Methods
    
    required override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.title = STVString.Lang(STVString.Favorites_Title)
    }
    
    override func viewDidAppear(animated: Bool) {
        setTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = STVString.Lang(STVString.Favorites_Title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectPlayButtonGesture = UITapGestureRecognizer(target: self, action: "playPress:")
        selectPlayButtonGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(selectPlayButtonGesture)
        
        self.dataSource = self
        
        var currentViewController : UIViewController?
        
        for photoEntity in photosList{
            let vc = STVUtils.getStoryBoard().instantiateViewControllerWithIdentifier("STVSingleFullPhotoViewController") as! STVSingleFullPhotoViewController
            vc.photoEntity = photoEntity
            listControllers.append(vc)
            
            if currentViewController == nil{
                currentViewController = vc
            }else if photoEntity == currentPhotoEntity{
                currentViewController = vc
            }
        }
        
        setViewControllers([currentViewController!], direction: .Forward, animated: false, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {        
        timer?.invalidate()
        timer = nil
        super.viewWillDisappear(animated)
    }

    
    //MARK: Internal Methods
    
    func setTimer(){
        if isPlaying == false{
            return
        }
        
        timer?.invalidate()
        timer = nil
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "next", userInfo: nil, repeats: true)
    }
    
    func next(){
        setViewControllers([getNextController()], direction: .Forward, animated: true, completion: nil)
    }
    
    func getNextController()->UIViewController{
        let index = listControllers.indexOf(self.viewControllers!.first!)!
        if (listControllers.count == (index + 1)){
            return listControllers.first!
        }
        
        return listControllers[index + 1]
    }
    
    func playPress(tap : UITapGestureRecognizer){
        
        let v = self.view.viewWithUniqueTag(111)
        if let _v = v{
            _v.removeFromSuperview()
        }
        
        let imagePlayPause = UIImageView(frame: CGRectMake(0, 0, 250, 250))
        
        imagePlayPause.alpha = 0
        imagePlayPause.contentMode = .ScaleAspectFit
        imagePlayPause.tag = 111
        imagePlayPause.userInteractionEnabled = false
        
        self.view.addSubview(imagePlayPause)
        imagePlayPause.centerInSuperview()
        
        if isPlaying == true{
            imagePlayPause.image = UIImage(named: "pause")
            isPlaying = false
            timer?.invalidate()
            timer = nil;
            print("Pause")
        }else{
            imagePlayPause.image = UIImage(named: "play")
            isPlaying = true
            setTimer()
            print("Playing")
        }
        
        imagePlayPause.alpha = 1
        UIView.animateWithDuration(3.0, animations: { () -> Void in
            imagePlayPause.alpha = 0
            }) { (value) -> Void in
                imagePlayPause.removeFromSuperview()
        }
        
    }
    
    //MARK: PageViewDelegate
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = listControllers.indexOf(viewController)!
        if index < listControllers.count - 1{
            setTimer()
            return listControllers[index + 1]
        }
        
        return nil
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return listControllers.indexOf(pageViewController.viewControllers!.first!)!
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = listControllers.indexOf(viewController)!
        if index > 0{
            setTimer()
            return listControllers[index - 1]
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return listControllers.count
    }

}
