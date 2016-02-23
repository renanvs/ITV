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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

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
        
        guard let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(tableView) else { return }
        guard let indexPath = context.nextFocusedIndexPath else { return }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewControllerWithIdentifier(segueIdentifierMap[indexPath.row])
        
        self.splitViewController?.showDetailViewController(controller, sender: nil)
        
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)

    
        
    }

}
