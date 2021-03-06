//
//  ClassSelectorView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
let identifier = "Cell"
class ClassSelectorView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var classData: [String] = []
    var classSelected = ""
    var instructor: Instructor! {
        didSet {
            self.layout()
        }
    }
    
    func layout() -> Void {
        classData = instructor.classes
    }
    
    override func awakeFromNib() {
        let cellNib = UINib(nibName: classTableViewCell, bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ClassTableViewCell
        let data = classData[indexPath.row]
        cell.classLabel.text = data
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        classSelected = classData[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverName.selector, object: nil, userInfo: [ObserverName.selected: ObserverName.cls, ObserverName.classSelected: classSelected])
    }

}
