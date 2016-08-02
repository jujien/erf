//
//  RoleSelectorView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class RoleSelectorView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        let cellNib = UINib(nibName: "ClassTableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "Cell")
    }

    var roleData: [String] = []
    var classCode = ""
    var roleSelected = ""
    var instructor: Instructor! {
        didSet {
            self.layout()
        }
    }
    
    func layout() -> Void {
        roleData = instructor.roleInClass(classCode)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roleData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ClassTableViewCell
        
        // Configure the cell...
        let data = roleData[indexPath.row]
        cell.classLabel.text = data
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        roleSelected = roleData[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName("Selector", object: nil, userInfo: ["Selected": "role", "roleSelected": roleSelected])
    }
}
