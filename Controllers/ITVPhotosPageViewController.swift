	//
//  ITVPhotosPageViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/17/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ITVPhotosPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var listControllers = [UIViewController]()
    var photosList = [PhotoEntity]()
    var currentPhotoEntity : PhotoEntity?
    var timer : NSTimer?
    
    required override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.title = "Favorites"
    }
    
    override func viewDidAppear(animated: Bool) {
        setTimer()
    }
    
    func setTimer(){
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Favorites"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        var currentViewController : UIViewController?
        
        for photoEntity in photosList{
            let vc = sb.instantiateViewControllerWithIdentifier("ITVSingleFullPhotoViewController") as! ITVSingleFullPhotoViewController
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
