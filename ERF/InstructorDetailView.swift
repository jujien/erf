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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let viewInfo = NSBundle.mainBundle().loadNibNamed("InstructorInfo", owner: self, options: nil)[0] as! UIView
        self.layoutIfNeeded()
        viewInfo.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(viewInfo)
        
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
}
