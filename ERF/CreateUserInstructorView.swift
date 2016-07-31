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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        done()
    }
    
    @IBAction func done() {
        if let username = usernameTextField.text where !username.isEmpty {
            self.username = username
        }
        if let phone = phoneTextField.text where !phone.isEmpty {
            self.phone = phone
        }
        usernameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
}
