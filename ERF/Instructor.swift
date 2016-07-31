//
//  Instructor.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class Instructor: Object {
    dynamic var imageUrl = ""
    dynamic var name = ""
    dynamic var code = ""
    dynamic var phone = ""
    var classRoles : List<ClassRole> = List<ClassRole>()
    
    class func create(imageUrl: String, name: String, code: String, phone: String, classRoles: List<ClassRole>) -> Instructor {
        let instructor = Instructor()
        instructor.imageUrl = imageUrl
        instructor.name = name
        instructor.code = code
        instructor.phone = phone
        instructor.classRoles = classRoles
        return instructor
    }
    
    var classes: [String] {
        get {
            var classCodes : [String] = []
            for classRole in self.classRoles {
                let classCode = classRole.classCode
                if !classCodes.contains(classCode) {
                    classCodes.append(Class.getTitle(classRole.classCode))
                }
            }
            return classCodes
        }
    }
    
    var roles: [String] {
        get {
            var roleCodes : [String] = []
            for classRole in self.classRoles {
                let roleCode = classRole.roleCode
                if !roleCodes.contains(roleCode) {
                    roleCodes.append(Role.getTitle(roleCode))
                }
            }
            return roleCodes
        }
    }
    
    func roleInClass(classCode: String) -> [String] {
        var roleCode = [String]()
        for classRole in self.classRoles {
            if classRole.classCode == classCode {
                roleCode.append(classRole.roleCode)
            }
        }
        return roleCode
    }
}