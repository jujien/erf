//
//  CreateClassRoleView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RealmSwift

class CreateClassRoleView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    let teams = ["ios", "android", "web", "c4e"]
    let roles = ["coach", "instructor"]
    
    var classRole: ClassRole!
    var team = ""
    var cls = ""
    var role = ""
    var classRoles = List<ClassRole>()
    override func awakeFromNib() {
        pickerView.delegate = self
        pickerView.dataSource = self
        finishButton.userInteractionEnabled = false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return teams.count
        } else if component == 1 {
            return 6
        } else {
            return roles.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return teams[row]
        } else if component == 1 {
            return "\(row)"
        } else {
            return roles[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //let font = UIFont(name: "Helvetica Neue", size: 15)!
        let attributes: [String: AnyObject] = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        if component == 0 {
            return NSAttributedString(string: teams[row], attributes: attributes)
        } else if component == 1 {
            return NSAttributedString(string: "\(row)", attributes: attributes)
        } else {
            return NSAttributedString(string: roles[row], attributes: attributes)
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 || component == 2 {
            return pickerView.frame.size.width * 2.0 / 5.0
        } else {
            return pickerView.frame.size.width / 5.0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            team = teams[row]
        } else if component == 1 {
            cls = "\(row)"
        } else {
            role = roles[row]
        }
        classRole = ClassRole.create(team + cls, roleCode: role)
    }
    
    @IBAction func addDidTapped(sender: UIButton) {
        classRoles.append(classRole)
    }
    
    @IBAction func finishDidTapped(sender: UIButton) {
    }
}
