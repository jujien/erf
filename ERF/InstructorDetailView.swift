//
//  InstructorDetailView.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class InstructorDetailView: UIView {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    var classData: [String] = []
    var selectedClassCode : String?
    var selectedRoleCode : String?
    var selectedDate : NSDate?
    
    var instructor: Instructor? {
        didSet {
            self.viewInstructorInfo()
        }
    }
    
    override func awakeFromNib() {
//        let viewInfo = NSBundle.mainBundle().loadNibNamed("InstructorInfoView", owner: self, options: nil)[0] as! UIView
//        self.layoutIfNeeded()
//        viewInfo.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
//        self.addSubview(viewInfo)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selected), name: "Selected", object: nil)
    }
    
    override func layoutSubviews() {
        self.configureUI()
    }
    func configureUI() -> Void {
        classButton.becomeRound()
        classButton.layer.borderWidth = 1.0
        classButton.layer.borderColor = UIColor.whiteColor().CGColor
        roleButton.becomeRound()
        roleButton.layer.borderWidth = 1.0
        roleButton.layer.borderColor = UIColor.whiteColor().CGColor
        dateButton.becomeRound()
        dateButton.layer.borderWidth = 1.0
        dateButton.layer.borderColor = UIColor.whiteColor().CGColor
        callButton.layer.cornerRadius = 6.0
        callButton.layer.masksToBounds = true
    }
    
    func viewInstructorInfo() -> Void {
        LazyImage.showForImageView(avatarImage, url: instructor?.imageUrl)
        nameLabel.text = instructor?.name
        phoneLabel.text = instructor?.phone
    }
    
    @IBAction func callDidTapped(sender: UIButton) {
        if let inst = instructor {
            let phone = "tel://"+inst.phone
            let url = NSURL(string: phone)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func classDidTapped(sender: UIButton) {
        configButtonColor(sender, otherButton1: roleButton, otherButton2: dateButton)
        NSNotificationCenter.defaultCenter().postNotificationName("DidTapped", object: nil, userInfo: ["DidTapped": "class"])
    }
    
    @IBAction func roleDidTapped(sender: UIButton) {
        configButtonColor(sender, otherButton1: classButton, otherButton2: roleButton)
        NSNotificationCenter.defaultCenter().postNotificationName("DidTapped", object: nil, userInfo: ["DidTapped": "role"])
    }
    
    @IBAction func dateDidTapped(sender: UIButton) {
        configButtonColor(sender, otherButton1: roleButton, otherButton2: classButton)
        NSNotificationCenter.defaultCenter().postNotificationName("DidTapped", object: nil, userInfo: ["DidTapped": "date"])
    }
    
    //configure button
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
    
    @objc
    func selected(notification: NSNotification) -> Void {
        let dict = notification.userInfo as! [String: String]
        if dict["Selected"] == "class" {
            classButton.setTitle(dict["classSelected"], forState: .Normal)
            roleButton.backgroundColor = UIColor(netHex: 0x04BF25)
            roleButton.userInteractionEnabled = true
            classButton.backgroundColor = UIColor(netHex: 0x5AC8FA)
        }
        if dict["Selected"] == "role" {
            roleButton.setTitle(dict["roleSelected"], forState: .Normal)
            dateButton.backgroundColor = UIColor(netHex: 0x04BF25)
            dateButton.userInteractionEnabled = true
            roleButton.backgroundColor = UIColor(netHex: 0x5AC8FA)
        }
        if dict["Selected"] == "time" {
            dateButton.setTitle(dict["timeSelected"], forState: .Normal)
        }
    }
    
    
}
