//
//  CreateUserInstructorView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit



class CreateUserInstructorView: UIView, UITextFieldDelegate, UIAlertViewDelegate{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var username = ""
    var phone = ""
    
    let identifierCenterContraintNameView = "contraintNameView"
    let identifierCenterContraintPhoneView = "ContraintPhoneView"
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(show), name: ObserverName.showKeyboard, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hide), name: ObserverName.hideKeyboard, object: nil)
        usernameTextField.delegate = self
        phoneTextField.delegate = self
        usernameTextField.text = username
        phoneTextField.text = phone
        
    }
    
    @IBAction func done() {
        if let username = usernameTextField.text where !username.isEmpty, let phone = phoneTextField.text where !phone.isEmpty {
            if isNumber(phone) {
                self.username = username
                self.phone = phone
                let object: [String: String] = [KeyJSON.name: username, KeyJSON.phone: phone]
                NSNotificationCenter.defaultCenter().postNotificationName(ObserverName.userObserver, object: nil, userInfo: object)
            } else {
                let alert = UIAlertView(title: "Lỗi", message: "Chỉ chứa số", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
        }
        if usernameTextField.editing && phoneTextField.text!.isEmpty {
            usernameTextField.resignFirstResponder()
            phoneTextField.becomeFirstResponder()
        } else if phoneTextField.editing && usernameTextField.text!.isEmpty {
            phoneTextField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        }
    }
    
    func alertViewCancel(alertView: UIAlertView) {
        phoneTextField.text = ""
        phoneTextField.becomeFirstResponder()
    }
    
    func isNumber(string: String) -> Bool {
        for c in string.characters {
            if c >= "0" && c <= "9" {
                return true
            }
        }
        return false
    }
    
    @objc
    func show(notification: NSNotification) {
        //usernameTextField.becomeFirstResponder()
//        if usernameTextField.becomeFirstResponder(){
//            let contraintUser = (self.constraints.filter({ (contraint) -> Bool in
//                return contraint.identifier == identifierCenterContraintNameView
//            }))[0]
//            let contraintPhone = (self.constraints.filter({ (contraint) -> Bool in
//                return contraint.identifier == identifierCenterContraintPhoneView
//            }))[0]
//            contraintPhone.constant = 50
//            contraintUser.constant = -50
//        }
//        if phoneTextField.becomeFirstResponder() {
//            let contraintUser = (self.constraints.filter({ (contraint) -> Bool in
//                return contraint.identifier == identifierCenterContraintNameView
//            }))[0]
//            let contraintPhone = (self.constraints.filter({ (contraint) -> Bool in
//                return contraint.identifier == identifierCenterContraintPhoneView
//            }))[0]
//            contraintUser.constant = -150
//            contraintPhone.constant = -50
//        }
    }
    
    @objc
    func hide(notification: NSNotification) {
//        let contraintUser = (self.constraints.filter({ (contraint) -> Bool in
//            return contraint.identifier == identifierCenterContraintNameView
//        }))[0]
//        let contraintPhone = (self.constraints.filter({ (contraint) -> Bool in
//            return contraint.identifier == identifierCenterContraintPhoneView
//        }))[0]
//        contraintPhone.constant = 50
//        contraintUser.constant = -50
    }
    
}
