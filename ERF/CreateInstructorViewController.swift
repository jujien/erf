//
//  CreateInstructorViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RealmSwift

class CreateInstructorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var classRoleButton: UIButton!
    
    var instructor: Instructor!
    var username = ""
    var phone = ""
    var team = ""
    var classRoles = List<ClassRole>()
    
    var currentViewInMaskView : UIView?
    var imagePicker: UIImagePickerController!
    var image: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCreateUser()
        nextStep()
        tapImage()
        
    }
    
    func tapImage() -> Void {
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc
    func takePhoto() -> Void {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    func configureUI() -> Void {
        self.navigationItem.title = "CREATE INSTRUCTOR"
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
        avatarImageView.layer.shadowColor = UIColor.blackColor().CGColor
        avatarImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        avatarImageView.layer.shadowOpacity = 1.0
        avatarImageView.layer.shadowRadius = 1.0
        avatarImageView.clipsToBounds = false
        userButton.layer.cornerRadius = userButton.frame.width / 2.0
        classRoleButton.layer.cornerRadius = classRoleButton.frame.width / 2.0
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    
    func loadCreateUser() -> Void {
        let userView = NSBundle.mainBundle().loadNibNamed("CreateUserInstructorView", owner: self, options: nil)[0] as! CreateUserInstructorView
        userView.frame = maskView.bounds
        userView.phone = phone
        userView.username = username
        addSubViewToSuperView(userView)
        
    }
    
    func loadCreateClassRole() -> Void {
        let classRoleView = NSBundle.mainBundle().loadNibNamed("CreateClassRoleView", owner: self, options: nil)[0] as! CreateClassRoleView
        classRoleView.frame = maskView.bounds
        classRoleView.team = team
        classRoleView.classRoles = classRoles
        addSubViewToSuperView(classRoleView)
    }
    
    func addSubViewToSuperView(subView: UIView) {
        for v in maskView.subviews {
            v.removeFromSuperview()
        }
        maskView.addSubview(subView)
        currentViewInMaskView = subView
    }
    
    func nextStep() -> Void {
        if !username.isEmpty && !phone.isEmpty {
            loadCreateClassRole()
            userButton.setImage(UIImage(named: "circle-tick-7"), forState: .Normal)
        }
    }
    
    
    @IBAction func registerDidTapped(sender: UIButton) {
        instructor = Instructor.create("image", name: username, code: "123", team: team, phone: phone, classRoles: classRoles)
    }

    @IBAction func userDidTapped(sender: UIButton) {
        loadCreateUser()
    }
    
    @IBAction func classRoleDidTapped(sender: UIButton) {
        loadCreateClassRole()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let logoImage = UIImage(named: "techkid")
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        logoImage!.drawInRect(CGRectMake((image.size.width - logoImage!.size.width)/2 , 10, logoImage!.size.width, logoImage!.size.height))
        let watermarkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        avatarImageView.image = watermarkImage
        if imagePicker.sourceType == .Camera {
            UIImageWriteToSavedPhotosAlbum(watermarkImage, nil, nil, nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
