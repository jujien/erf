//
//  ClassRole.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class ClassRole: Object {
    dynamic var classCode = ""
    dynamic var roleCode = ""
    
    class func create(classCode: String, roleCode: String) -> ClassRole {
        let classRole = ClassRole()
        classRole.classCode = classCode
        classRole.roleCode = roleCode
        return classRole
    }
}