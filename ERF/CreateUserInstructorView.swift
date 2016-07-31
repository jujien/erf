//
//  CreateUserInstructorView.swift
//  ERF
//
//  Created by Vũ Kiên on 28/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class CreateUserInstructorView: UIView, UITextFieldDelegate{

    
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
            self.username = username
            self.phone = phone
            let object: [String: String] = ["username": username, "phone": phone]
            NSNotificationCenter.defaultCenter().postNotificationName("Complete User", object: nil, userInfo: object)
        }
        
        
        usernameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
}
