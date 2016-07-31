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

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
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
            let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LeftViewController")
            let searchNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationSearch") as!UINavigationController
            let slideViewController = SlideMenuController(mainViewController: searchNavigationController, leftMenuViewController: leftViewController)
            self.view.window?.rootViewController = slideViewController
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Please check your Username or Password", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
