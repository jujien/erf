//
//  Role.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class Role: Object {
    dynamic var code = ""
    dynamic var title = ""
    
    static var all: [Role] = []
    
    static override func ignoredProperties() -> [String] {
        return ["all"]
    }
    
    class func create(code: String, title: String) -> Role {
        let role = Role()
        role.code = code
        role.title = title
        return role
    }
    
    class func getTitle(code: String) -> String {
        let foundItem = all.filter { (item) -> Bool in
            return item.code == code
        }
        if let foundItem = foundItem.first {
            return foundItem.title
        } else {
            return code
        }
    }
    
    class func get(code: String) -> Role? {
        let foundItem = all.filter { (item) -> Bool in
            return item.code == code
        }
        
        if let foundItem = foundItem.first {
            return foundItem
        } else {
            return nil
        }
        
    }
}