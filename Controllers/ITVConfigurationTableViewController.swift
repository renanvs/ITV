//
//  ITVConfiguratiomViewController.swift
//  InstaTV
//
//  Created by renan silva on 2/21/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

enum ConfigurationType : Int{
    case Profile, Favorites
}

class ITVConfigurationTableViewController: UITableViewController{
    
    var currentType = ConfigurationType.Favorites

    //@IBOutlet weak var configTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    var segueIdentifierMap: [String] {
        return
            [
                "ITVFaceProfileViewController",
                "ITVFavoriteConfigViewController"
            ]
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ConfigCell\(indexPath.row)"
        
        currentType = ConfigurationType(rawValue: indexPath.row)!
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        // Check that the next focus view is a child of the table view.
        guard let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(tableView) else { return }
        guard let indexPath = context.nextFocusedIndexPath else { return }
        
        // Create an `NSBlockOperation` to perform the detail segue after a delay.
        //let segueIdentifier = segueIdentifierMap[indexPath.section][indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewControllerWithIdentifier(segueIdentifierMap[indexPath.row])
        let navController = self.splitViewController?. viewControllers.first
        let navController2 = self.splitViewController?.viewControllers.last
        let count = self.splitViewController?.viewControllers.count
        //navController.pushViewController(controller, animated: true)
        
            // Pause the block so the segue isn't immediately performed.
            //NSThread.sleepForTimeInterval(MenuTableViewController.performSegueDelay)
            
            /*
            Check that the operation wasn't cancelled and that the segue identifier
            is different to the last performed segue identifier.
            */
        
            
            //NSOperationQueue.mainQueue().addOperationWithBlock {
                // Perform the segue to show the detail view controller.
                //self.performSegueWithIdentifier(segueIdentifier, sender: nextFocusedView)
                
                // Record the last performed segue identifier.
                //self.lastPerformedSegueIdentifier = segueIdentifier
                self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)

    
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "test", userInfo: nil, repeats: true)
    }
    
    func test(){
        let indexPath = NSIndexPath(forRow: currentType.rawValue, inSection: 0)
//        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
//        cell?.setSelected(true, animated: true)
        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("row:\(indexPath.row) || section:\(indexPath.section)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
