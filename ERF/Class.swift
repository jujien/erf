//
//  Class.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class Class: Object {
    dynamic var title = ""
    dynamic var code = ""
    
    static var all: [Class] = []
    
    static override func ignoredProperties() -> [String] {
        return ["all"]
    }
    
    class func create(title: String, code: String) -> Class {
        let classes = Class()
        classes.title = title
        classes.code = code
        return classes
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
    
    class func get(code: String) -> Class? {
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