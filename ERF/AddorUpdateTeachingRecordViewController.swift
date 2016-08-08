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
    
    var classSelected = ""
    var roleSelected = ""
    var timeSelected = ""
    var submitSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        loadDetail()
        loadClass()
        chooseStep()
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selector), name: ObserverName.selector, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        let statusBar: UIStatusBarStyle = .LightContent
        return statusBar
    }
    
    //MARK: change view
    func nextStep() -> Void {
        if classSelected != "" {
            loadRole()
            NSNotificationCenter.defaultCenter().postNotificationName(ObserverName.selected, object: nil, userInfo: [ObserverName.selected: ObserverName.cls, ObserverName.classSelected: classSelected])
        }
        
        if roleSelected != "" {
            loadCalendar()
            NSNotificationCenter.defaultCenter().postNotificationName(ObserverName.selected, object: nil, userInfo: [ObserverName.selected: ObserverName.role, ObserverName.roleSelected: roleSelected])
        }
        
        if timeSelected != "" {
            NSNotificationCenter.defaultCenter().postNotificationName(ObserverName.selected, object: nil, userInfo: [ObserverName.selected: ObserverName.time, ObserverName.timeSelected: timeSelected])
        }
        
        if submitSelected != "" {
            //
        }
    }
    
    func chooseStep() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didTapped), name: ObserverName.didTapped, object: nil)
    }
    
    
    //MARK: method observer
    @objc
    func selector(notification: NSNotification) -> Void {
        let dict = notification.userInfo as! [String: String]
        if dict[ObserverName.selected] == ObserverName.cls {
            classSelected = dict[ObserverName.classSelected]!
            nextStep()
        } else if dict[ObserverName.selected] == ObserverName.role {
            roleSelected = dict[ObserverName.roleSelected]!
            nextStep()
        } else if dict[ObserverName.selected] == ObserverName.time {
            timeSelected = dict[ObserverName.time]!
            submitSelected = dict[ObserverName.submitFlag]!
            nextStep()
        }
        
    }
    
    @objc
    func didTapped (notification: NSNotification) {
        let dict = notification.userInfo as! [String: String]
        if dict[ObserverName.didTapped] == ObserverName.cls {
            loadClass()
        } else if dict[ObserverName.didTapped] == ObserverName.role {
            loadRole()
        } else if dict[ObserverName.didTapped] == ObserverName.time {
            loadCalendar()
        }
        
    }
    
    
    //MARK: loadView
    func loadDetail() -> Void {
        let viewInfo = NSBundle.mainBundle().loadNibNamed(intructorView, owner: self, options: nil)[0] as! InstructorDetailView
        viewInfo.frame = instructorView.bounds
        viewInfo.instructor = instructor
        instructorView.addSubview(viewInfo)
    }
    
    func loadClass() -> Void {
        let viewClass = NSBundle.mainBundle().loadNibNamed(classview, owner: self, options: nil)[0] as! ClassSelectorView
        viewClass.instructor = instructor
        viewClass.frame = maskView.bounds
        viewClass.classSelected = classSelected
        addSubViewToSuperView(viewClass)
    }
    
    func loadRole() -> Void {
        let roleView = NSBundle.mainBundle().loadNibNamed(roleview, owner: self, options: nil)[0] as! RoleSelectorView
        roleView.roleData = (instructor?.roleInClass(classSelected))!
        roleView.frame = maskView.bounds
        roleView.roleSelected = roleSelected
        addSubViewToSuperView(roleView)
    }
    
    func loadCalendar() -> Void {
        let calendarView = NSBundle.mainBundle().loadNibNamed(calendarview, owner: self, options: nil)[0] as! DateSelectorView
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
