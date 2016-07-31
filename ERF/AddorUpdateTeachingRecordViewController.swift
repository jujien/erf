//
//  AddorUpdateTeachingRecordViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RealmSwift

class AddorUpdateTeachingRecordViewController: UIViewController {
    
    @IBOutlet weak var instructorView: InstructorDetailView!
    @IBOutlet weak var maskView: UIView!
    
    var currentViewInMaskView : UIView?
    var instructor : Instructor?
    var instructrClass = ""
    var instructorRole = ""
    var dateUpdate = ""
    var teachingRecordId = ""
    var isUpdate = false
    
    var classSelected = ""
    var roleSelected = ""
    var timeSelected = ""
    var submitSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        instructorView.instructor = instructor
        loadClass()
        chooseStep()
        nextStep()
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextStep() -> Void {
        if classSelected != "" {
            loadRole()
            instructorView.classButton.setTitle(classSelected, forState: .Normal)
            instructorView.roleButton.backgroundColor = UIColor(netHex: 0x04BF25)
            instructorView.roleButton.userInteractionEnabled = true
            instructorView.classButton.backgroundColor = UIColor(netHex: 0x5AC8FA)
        }
        
        if roleSelected != "" {
            loadCalendar()
            instructorView.roleButton.setTitle(roleSelected, forState: .Normal)
            instructorView.dateButton.backgroundColor = UIColor(netHex: 0x04BF25)
            instructorView.dateButton.userInteractionEnabled = true
            instructorView.roleButton.backgroundColor = UIColor(netHex: 0x5AC8FA)
        }
        
        if timeSelected != "" {
            instructorView.dateButton.setTitle(timeSelected, forState: .Normal)
        }
        
        if submitSelected != "" {
            
        }
    }
    
    func chooseStep() -> Void {
        instructorView.classButton.addTarget(self, action: #selector(classDidTapped), forControlEvents: .TouchUpInside)
        instructorView.roleButton.addTarget(self, action: #selector(roleDidTapped), forControlEvents: .TouchUpInside)
        instructorView.dateButton.addTarget(self, action: #selector(dateDidTapped), forControlEvents: .TouchUpInside)
    }
    
    @objc
    func classDidTapped (sender: UIButton) {
        loadClass()
        configButtonColor(sender, otherButton1: instructorView.roleButton, otherButton2: instructorView.dateButton)
    }
    
    @objc
    func roleDidTapped(sender: UIButton) {
        loadRole()
        configButtonColor(sender, otherButton1: instructorView.classButton, otherButton2: instructorView.roleButton)
    }
    
    @objc
    func dateDidTapped(sender: UIButton) {
        loadCalendar()
        configButtonColor(sender, otherButton1: instructorView.roleButton, otherButton2: instructorView.classButton)
    }
    
    func configButtonColor(selectedButton : UIButton, otherButton1 : UIButton, otherButton2 : UIButton) {
        selectedButton.backgroundColor = UIColor(netHex: 0x04BF25)
        if otherButton1.userInteractionEnabled {
            otherButton1.backgroundColor = UIColor(netHex: 0x5AC8FA)
        } else {
            otherButton1.backgroundColor = UIColor.grayColor()
        }
        
        if otherButton2.userInteractionEnabled {
            otherButton2.backgroundColor = UIColor(netHex: 0x5AC8FA)
        } else {
            otherButton2.backgroundColor = UIColor.grayColor()
        }
    }
    
    func loadClass() -> Void {
        let viewClass = NSBundle.mainBundle().loadNibNamed("ClassSelectorView", owner: self, options: nil)[0] as! ClassSelectorView
        viewClass.instructor = instructor
        viewClass.frame = maskView.bounds
        viewClass.classSelected = classSelected
        addSubViewToSuperView(viewClass)
    }
    
    func loadRole() -> Void {
        let roleView = NSBundle.mainBundle().loadNibNamed("RoleSelectorView", owner: self, options: nil)[0] as! RoleSelectorView
        roleView.roleData = (instructor?.roleInClass(classSelected))!
        roleView.frame = maskView.bounds
        roleView.roleSelected = roleSelected
        addSubViewToSuperView(roleView)
    }
    
    func loadCalendar() -> Void {
        let calendarView = NSBundle.mainBundle().loadNibNamed("CalendarSelector", owner: self, options: nil)[0] as! DateSelectorView
        calendarView.frame = maskView.bounds
        calendarView.time = timeSelected
        calendarView.submitFlag = submitSelected
        addSubViewToSuperView(calendarView)
    }
    
    func addSubViewToSuperView(subView: UIView) {
        for v in maskView.subviews {
            v.removeFromSuperview()
        }
        maskView.addSubview(subView)
        currentViewInMaskView = subView
    }

}
