//
//  LeftViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 26/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
let identifierMenu = "Cell"
class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuItems: [LeftMenuItem] = [LeftMenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuItems = LeftMenuItem.MenuItem
        self.setupLayout()
    }
    
    func setupLayout() -> Void {
        self.view.layoutIfNeeded()
        self.iconImageView.layoutIfNeeded()
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width/2.0
        self.iconImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.iconImageView.layer.shadowOpacity = 0.8
        self.iconImageView.layer.shadowOffset = CGSizeZero
        self.iconImageView.layer.shadowRadius = 10.0
        self.iconImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifierMenu, forIndexPath: indexPath) as! MenuTableViewCell
        let menuItem = menuItems[indexPath.row]
        cell.menuItem = menuItem
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuItem = menuItems[indexPath.row]
        if menuItem.idViewController == "" {
            let alert = UIAlertController(title: "Logout", message: "Do you want logout?", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "YES", style: .Default, handler: { (action) in
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier(loginVC)
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            })
            let noAction = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier(menuItem.idViewController!)
            self.slideMenuController()?.changeMainViewController(viewController, close: true)
        }
        
    }
    

}
