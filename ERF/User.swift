//
//  User.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var userName : String = ""
    dynamic var password : String = ""
    
    class func create(userName: String, passwrod: String) -> User {
        let user = User()
        user.userName = userName
        user.password = passwrod
        return user
    }
    
    class func checkLogin(userName: String, password: String) -> Bool {
        if userName == "admin" && password == "admin" {
            return true
        } else {
            return false
        }
    }
}