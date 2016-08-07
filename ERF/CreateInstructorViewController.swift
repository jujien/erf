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
import AssetsLibrary

class CreateInstructorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var classRoleButton: UIButton!
    
    //var instructor: Instructor!
    var imageURL = ""
    var imagePath = ""
    var username = ""
    var phone = ""
    var classRoles = List<ClassRole>()
    
    var currentViewInMaskView : UIView?
    var imagePicker: UIImagePickerController!
    var image: UIImage!
    
    let S3BuketName = "iliat-demo-app"
    let CognitoPoolID = "us-west-2:146358ec-81cc-41dd-acb8-5fb66313ea33"
    let Region = AWSRegionType.USWest2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classRoleButton.userInteractionEnabled = false
        loadCreateUser()
        tapImage()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(completeClassRoles), name: "Complete ClassRoles", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(completeUser), name: "Complete User", object: nil)
        
        
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
        username = notification.userInfo!["username"] as! String
        phone = notification.userInfo!["phone"] as! String
        nextStep()
    }
    
    @objc
    func completeClassRoles(notification: NSNotification) -> Void {
        classRoles = notification.userInfo!["classRoles"] as! List<ClassRole>
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
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    
    //MARK: Load View
    func loadCreateUser() -> Void {
        let userView = NSBundle.mainBundle().loadNibNamed("CreateUserInstructorView", owner: self, options: nil)[0] as! CreateUserInstructorView
        userView.frame = maskView.bounds
        userView.username = username
        userView.phone = phone
        addSubViewToSuperView(userView)
        
    }
    
    func loadCreateClassRole() -> Void {
        let classRoleView = NSBundle.mainBundle().loadNibNamed("CreateClassRoleView", owner: self, options: nil)[0] as! CreateClassRoleView
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
            let alert = UIAlertController(title: "Create Fail!", message: "Complete User and ClassRoles", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "Complete User", object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "Complete ClassRoles", object: nil)
            var clsRoles: [AnyObject] = []
            for c in classRoles {
                let clsRole = ["className": c.classCode, "role": c.roleCode]
                clsRoles.append(clsRole)
            }
            
            let tempPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("avatar.png")
            let dataImage = UIImagePNGRepresentation(avatarImageView.image!)
            if dataImage?.writeToURL(tempPath, atomically: true) == true {
                print("write to completed")
            } else {
                print("error")
                return
            }
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType:Region,
                                                                    identityPoolId:CognitoPoolID)
            let configuration = AWSServiceConfiguration(region:Region, credentialsProvider:credentialsProvider)
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest.body = tempPath
            uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + ".png"
            uploadRequest.bucket = S3BuketName
            uploadRequest.contentType = "image/png"
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                }
                if let exception = task.exception {
                    print("Upload failed ❌ (\(exception))")
                }
                if task.result != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageURL = (NSURL(string: "http://s3.amazonaws.com/\(self.S3BuketName)/\(uploadRequest.key!)")!).absoluteString
                        print("Uploaded to:\n\(self.imageURL)")
                    })
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                return nil
            }
            if imageURL != "" {
                let instructor = ["name":username, "phone": phone, "code": "TECH10", "imageURL": imageURL, "classRole": clsRoles]
                Alamofire.request(.POST, urlProducts, parameters: instructor as? [String : AnyObject], encoding: .JSON).response(completionHandler: { (resquest, response, data, error) in
                    if let error = error {
                        print("error: \(error)")
                        return
                    }
                    print("success")
                    NetworkConfig.shareInstance.socketServerEvent("New instructor")
                })
            }
            
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
            //UIImageWriteToSavedPhotosAlbum(watermarkImage, nil, nil, nil)
            let library = ALAssetsLibrary()
            library.writeImageToSavedPhotosAlbum(watermarkImage.CGImage, orientation: ALAssetOrientation(rawValue: watermarkImage.imageOrientation.rawValue)!, completionBlock: { (url, error) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                self.imagePath = url.absoluteString
                print(self.imagePath)
            })
        } else if imagePicker.sourceType == .PhotoLibrary {
            let library = ALAssetsLibrary()
            library.writeImageToSavedPhotosAlbum(watermarkImage.CGImage, orientation: ALAssetOrientation(rawValue: watermarkImage.imageOrientation.rawValue)!, completionBlock: { (url, error) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                self.imagePath = url.absoluteString
                print(self.imagePath)
            })
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
