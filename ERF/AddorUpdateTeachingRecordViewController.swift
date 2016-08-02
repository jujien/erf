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
    
    @IBOutlet weak var instructorView: UIView!
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
        loadDetail()
        loadClass()
        chooseStep()
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selector), name: "Selector", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewDidAppear(animated)
        
    }
    
    //MARK: change view
    func nextStep() -> Void {
        if classSelected != "" {
            loadRole()
            NSNotificationCenter.defaultCenter().postNotificationName("Selected", object: nil, userInfo: ["Selected": "class", "classSelected": classSelected])
        }
        
        if roleSelected != "" {
            loadCalendar()
            NSNotificationCenter.defaultCenter().postNotificationName("Selected", object: nil, userInfo: ["Selected": "role", "roleSelected": roleSelected])
        }
        
        if timeSelected != "" {
            NSNotificationCenter.defaultCenter().postNotificationName("Selected", object: nil, userInfo: ["Selected": "time", "timeSelected": timeSelected])
        }
        
        if submitSelected != "" {
            //
        }
    }
    
    func chooseStep() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didTapped), name: "DidTapped", object: nil)
    }
    
    
    //MARK: method observer
    @objc
    func selector(notification: NSNotification) -> Void {
        let dict = notification.userInfo as! [String: String]
        if dict["Selected"] == "class" {
            classSelected = dict["classSelected"]!
            nextStep()
        } else if dict["Selected"] == "role" {
            roleSelected = dict["roleSelected"]!
            nextStep()
        } else if dict["Selected"] == "date" {
            timeSelected = dict["time"]!
            submitSelected = dict["submitFlag"]!
            nextStep()
        }
        
    }
    
    @objc
    func didTapped (notification: NSNotification) {
        let dict = notification.userInfo as! [String: String]
        if dict["DidTapped"] == "class" {
            loadClass()
        } else if dict["DidTapped"] == "role" {
            loadRole()
        } else if dict["DidTapped"] == "date" {
            loadCalendar()
        }
        
    }
    
    
    //MARK: loadView
    func loadDetail() -> Void {
        let viewInfo = NSBundle.mainBundle().loadNibNamed("InstructorInfoView", owner: self, options: nil)[0] as! InstructorDetailView
        viewInfo.frame = instructorView.bounds
        viewInfo.instructor = instructor
        instructorView.addSubview(viewInfo)
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
        let calendarView = NSBundle.mainBundle().loadNibNamed("CalendarSelectorView", owner: self, options: nil)[0] as! DateSelectorView
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
