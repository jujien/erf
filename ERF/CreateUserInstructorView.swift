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
    
    override func awakeFromNib() {
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
                let object: [String: String] = ["username": username, "phone": phone]
                NSNotificationCenter.defaultCenter().postNotificationName("Complete User", object: nil, userInfo: object)
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
    
}
