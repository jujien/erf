//
//  NavigationController.swift
//  ERF
//
//  Created by Vũ Kiên on 02/08/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        self.interactivePopGestureRecognizer?.enabled = true
    }
    

}
