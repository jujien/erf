//
//  UIViewControllerExtension.swift
//  ERP
//
//  Created by Mr.Vu on 6/19/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(titleAlert: String, message: String, titleActions: [String], actions: [((UIAlertAction) -> Void)?]?, complete: (() -> Void)?) -> Void {
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: .Alert)
        for i in 0..<titleActions.count {
            let actionAlert = UIAlertAction(title: titleActions[i], style: .Default, handler: { (action) in
                if let actions = actions {
                    if let a = actions[i] {
                        a(action)
                    }
                }
                
            })
            alert.addAction(actionAlert)
        }
        presentViewController(alert, animated: true, completion: complete)
    }
}