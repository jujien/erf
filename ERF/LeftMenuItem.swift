//
//  LeftMenu.swift
//  ERF
//
//  Created by Vũ Kiên on 26/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation

class LeftMenuItem {
    let icon: String?
    let title: String?
    let idViewController: String?
    
    init(icon: String?, title: String?, idViewController: String?) {
        self.icon = icon
        self.title = title
        self.idViewController = idViewController
    }
    
    class var MenuItem: [LeftMenuItem] {
        get {
            return [
               LeftMenuItem(icon: "img-search", title: "SEARCH INSTRUCTOR", idViewController: naviSearchVC),
               LeftMenuItem(icon: "camera-7", title: "CREATE", idViewController: naviCreateVC),
               LeftMenuItem(icon: "img-logout", title: "LOGOUT", idViewController: "")
            ]
        }
    }
}
