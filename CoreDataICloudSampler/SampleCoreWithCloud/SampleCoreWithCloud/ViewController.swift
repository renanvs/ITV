//
//  ViewController.swift
//  SampleCoreWithCloud
//
//  Created by renanvs on 2/15/16.
//  Copyright © 2016 mwg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var lista = AlbumEntity.getAll()
    
    @IBOutlet weak var tb : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        print("")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("update"), name: "updateList", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func update(){
        lista = AlbumEntity.getAll()
        tb.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        
        let alb = lista[indexPath.row]
        
        label.text = alb.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    var index : Int = 0
    
    @IBAction func pressed(){
        
        let entity = AlbumEntity.newEntity()
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy_MM_dd_hh_mm_ss_sss"
        
        entity.name = "ola album\(formater.stringFromDate(NSDate()))"
        entity.coverPhotoId = "1"
        entity.identifier = "2"
        entity.photoCount = NSNumber(int: 4)
        entity.remoteCoverUrl = "3"
        

        CCCoreData.saveContext()
        update()
    }

//    func test(){
//        if AlbumEntity.getAll().count == 0{
//            let entity = AlbumEntity.newEntity()
//            entity.name = "ola album"
//            CCCoreData.saveContext()
//        }else{
//            let str = (AlbumEntity.getAll().first?.name)!
//            print("\(str)")
//        }
//    }
}

