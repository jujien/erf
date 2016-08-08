//
//  LoginViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 26/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let identifierBottomLogin = "bottomLoginView"
    let identifierCenterImage = "centerContraintImage"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showKeyboard), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    @objc
    func showKeyboard(notification: NSNotification) {
        //loginView.setNeedsLayout()
        let bottomContraintLogin = (view.constraints.filter({ (contraint) -> Bool in
            return contraint.identifier == identifierBottomLogin
        }))[0]
        let centerContraintImage = (view.constraints.filter({ (contraint) -> Bool in
            return contraint.identifier == identifierCenterImage
        }))[0]
        bottomContraintLogin.constant = 170
        centerContraintImage.constant = -100
    }
    @objc
    func hideKeyboard(notification: NSNotification) {
        let bottomContraintLogin = (view.constraints.filter({ (contraint) -> Bool in
            return contraint.identifier == identifierBottomLogin
        }))[0]
        let centerContraintImage = (view.constraints.filter({ (contraint) -> Bool in
            return contraint.identifier == identifierCenterImage
        }))[0]
        bottomContraintLogin.constant = 50
        centerContraintImage.constant = 0
    }

    func setupUI() -> Void {
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2.0
        iconImageView.layer.shadowColor = UIColor.blackColor().CGColor
        iconImageView.layer.shadowOffset = CGSizeMake(0, 1)
        iconImageView.layer.shadowOpacity = 1.0
        iconImageView.layer.shadowRadius = 1.0
        iconImageView.clipsToBounds = false
    }
    
    @IBAction func loginDidTapped(sender: UIButton) {
        if usernameTextField.text == "admin" && passwordTextField.text == "admin" {
            let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier(leftMenu)
            let searchNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier(naviSearchVC) as! NavigationController
            let slideViewController = SlideMenuController(mainViewController: searchNavigationController, leftMenuViewController: leftViewController)
            self.view.window?.rootViewController = slideViewController
        } else {
            showAlert("Login Failed", message: "Please check your Username or Password", titleActions: ["OK"], actions: nil, complete: nil)
        }
    }
    
    @IBAction func done() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    

}
