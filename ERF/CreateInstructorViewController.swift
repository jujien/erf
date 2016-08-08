//
//  CreateInstructorViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AWSS3
import ReachabilitySwift

let S3BuketName = "iliat-app"
let CognitoPoolID = "us-west-2:146358ec-81cc-41dd-acb8-5fb66313ea33"
let Region = AWSRegionType.USWest2
class CreateInstructorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var classRoleButton: UIButton!
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    
    //var instructor: Instructor!
    var imageURL = ""
    var username = ""
    var phone = ""
    var classRoles = List<ClassRole>()
    
    var currentViewInMaskView : UIView?
    var imagePicker: UIImagePickerController!
    var image: UIImage!
    
    var reachability : Reachability?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classRoleButton.userInteractionEnabled = false
        loadCreateUser()
        tapImage()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(completeClassRoles), name: ObserverName.classRoleObserver, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(completeUser), name: ObserverName.userObserver, object: nil)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    //MARK: choose or take photo
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
    
    //MARK: method observer
    @objc
    func completeUser(notification: NSNotification) -> Void {
        username = notification.userInfo![KeyJSON.name] as! String
        phone = notification.userInfo![KeyJSON.phone] as! String
        nextStep()
    }
    
    @objc
    func completeClassRoles(notification: NSNotification) -> Void {
        classRoles = notification.userInfo![KeyJSON.classRole] as! List<ClassRole>
        classRoleButton.setImage(UIImage(named: "circle-tick-7"), forState: .Normal)
    }
    
    //ConfigureUI
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
        waitIndicator.hidden = true
        waitIndicator.stopAnimating()
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    
    //MARK: Load View
    func loadCreateUser() -> Void {
        let userView = NSBundle.mainBundle().loadNibNamed(createUserView, owner: self, options: nil)[0] as! CreateUserInstructorView
        userView.frame = maskView.bounds
        userView.username = username
        userView.phone = phone
        addSubViewToSuperView(userView)
        
    }
    
    func loadCreateClassRole() -> Void {
        let classRoleView = NSBundle.mainBundle().loadNibNamed(createClassRoleView, owner: self, options: nil)[0] as! CreateClassRoleView
        classRoleView.frame = maskView.bounds
        addSubViewToSuperView(classRoleView)
    }
    
    func addSubViewToSuperView(subView: UIView) {
        for v in maskView.subviews {
            v.removeFromSuperview()
        }
        maskView.addSubview(subView)
        currentViewInMaskView = subView
    }
    
    //Change View
    func nextStep() -> Void {
        if !username.isEmpty && !phone.isEmpty {
            loadCreateClassRole()
            userButton.setImage(UIImage(named: "circle-tick-7"), forState: .Normal)
            classRoleButton.userInteractionEnabled = true
        }
    }
    
    @IBAction func registerDidTapped(sender: UIButton) {
        if username.isEmpty || phone.isEmpty || classRoles.isEmpty {
            showAlert("Create Fail!", message: "Complete User and ClassRoles", titleActions: ["OK"], actions: nil, complete: nil)
        } else {
            waitIndicator.hidden = false
            waitIndicator.startAnimating()
            self.view.userInteractionEnabled = false
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ObserverName.userObserver, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ObserverName.classRoleObserver, object: nil)
            
            writeImageToTemp()
            
            uploadData()
        }
        
    }

    @IBAction func userDidTapped(sender: UIButton) {
        loadCreateUser()
    }
    
    @IBAction func classRoleDidTapped(sender: UIButton) {
        loadCreateClassRole()
    }
    
    //MARK: PickerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let logoImage = UIImage(named: "techkid")
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        logoImage!.drawInRect(CGRectMake(0 , 0, image!.size.width, image!.size.height))
        let watermarkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        avatarImageView.image = watermarkImage
        if imagePicker.sourceType == .Camera {
            UIImageWriteToSavedPhotosAlbum(watermarkImage, nil, nil, nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pathImage(imageName: String) -> NSURL {
        return NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imageName)
    }
    
    func writeImageToTemp() -> Void {
        let tempPath = pathImage("avatar\(username).jpeg")
        let dataImage = UIImageJPEGRepresentation(avatarImageView.image!, 0.5)
        if dataImage?.writeToURL(tempPath, atomically: true) == true {
            print("write to completed")
        } else {
            print("error")
            return
        }
    }
    
    func uploadData() -> Void {
        var clsRoles: [AnyObject] = []
        for c in classRoles {
            let clsRole = [KeyJSON.className: c.classCode, KeyJSON.role: c.roleCode]
            clsRoles.append(clsRole)
        }
        do {
            reachability = try! Reachability.reachabilityForInternetConnection()
        }
        reachability?.whenReachable = {
            reachability in
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest.body = self.pathImage("avatar\(self.username).jpeg")
            uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + ".jpeg"
            uploadRequest.bucket = S3BuketName
            uploadRequest.contentType = "image/jpeg"
            let transferManager = AWSS3TransferManager.S3TransferManagerForKey(key)
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                if let error = task.error {
                    self.showAlert("Upload failed ❌", message: "\(error.description)", titleActions: ["OK"], actions: nil, complete: nil)
                    print("Upload failed ❌ (\(error))")
                    return nil
                }
                if let exception = task.exception {
                    self.showAlert("Upload failed ❌", message: "\(exception.description)", titleActions: ["OK"], actions: nil, complete: nil)
                    print("Upload failed ❌ (\(exception))")
                    return nil
                }
                if task.result != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageURL = (NSURL(string: urlS3 + "/\(S3BuketName)/\(uploadRequest.key!)")!).absoluteString
                        print("Uploaded to:\n\(self.imageURL)")
                        let instructor = [KeyJSON.name: self.username, KeyJSON.phone: self.phone, KeyJSON.code: "TECH10", KeyJSON.imageURL: self.imageURL, KeyJSON.classRole: clsRoles]
                        Alamofire.request(.POST, urlProducts, parameters: instructor as? [String : AnyObject], encoding: .JSON).response(completionHandler: { (resquest, response, data, error) in
                            if let error = error {
                                self.showAlert("Error", message: "\(error.description)", titleActions: ["OK"], actions: nil, complete: nil)
                                print("error: \(error)")
                                return
                            }
                            print("success")
                            NetworkConfig.shareInstance.socketServerEvent("New instructor \(self.username)")
                            self.waitIndicator.stopAnimating()
                            self.waitIndicator.hidden = true
                            self.showAlert("Success!", message: "Create Completed", titleActions: ["OK"], actions: nil, complete: nil)
                        })
                    })
                    
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                return nil
            }
        }
        reachability!.whenUnreachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue(), {
                self.waitIndicator.stopAnimating()
            })
        }
        try! reachability?.startNotifier()
    }
}
