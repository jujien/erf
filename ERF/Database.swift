//
//  Database.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    static let realm = try! Realm()
    
//    class func loginFirstTime(login : User) {
//        try! realm.write {
//            realm.add(login)
//        }
//    }
    
    
    class func getUser() -> User? {
        return realm.objects(User).first
    }
    
    class func getUserByName(name : String) -> User?{
        let predicate = NSPredicate(format: "userName = %@",name)
        return realm.objects(User).filter(predicate).first
    }
    
    class func getLogin() -> User? {
        let result = realm.objects(User).first
        return result
    }
    
    class func addInstructor(instructor: Instructor) {
        try! realm.write {
            realm.add(instructor);
        }
    }
    
    class func addOrUpdateInstructor(instructor: Instructor) {
        let foundInstructorOpt = realm.objects(Instructor).filter("code == '\(instructor.code)'").first
        if let foundInstructor = foundInstructorOpt {
            try! realm.write {
                // MARK: Test update classroles for instructor
                foundInstructor.classRoles = instructor.classRoles
            }
        } else {
            try! realm.write {
                realm.add(instructor)
            }
        }
    }
    
    class func findInstructorByCode(code: String) -> Instructor? {
        let foundInstructors = realm.objects(Instructor).filter("code == \(code)")
        if foundInstructors.count == 0 {
            return nil
        } else if (foundInstructors.count == 1) {
            return foundInstructors[0];
        } else {
            print("Inconsistent database: More than one intructor with indentical code")
            return foundInstructors[0];
        }
    }
    
    class func getAllInstructors() -> [Instructor] {
        var instructors = [Instructor]()
        let result = realm.objects(Instructor.self)
        for rs in result {
            instructors.append(rs)
        }
        
        return instructors
    }
    
    class func getInstructorByCode(code : String) -> Instructor? {
        let predicate = NSPredicate(format: "code = %@", code)
        return realm.objects(Instructor).filter(predicate).first
    }
    
    class func deleteAllInstructors() {
        let instructors = getAllInstructors()
        for instructor in instructors {
            try! realm.write {
                realm.delete(instructor)
            }
        }
    }
    
    class func addInstructorTeachingRecord(instTeachingRecord : TeachingRecord) {
        try! realm.write {
            realm.add(instTeachingRecord)
        }
    }
    
    class func getAllInstructorTeachingRecords() -> [TeachingRecord] {
        return realm.objects(TeachingRecord).map {
            record in
            return record
        }
    }
    
    class func updateTeachingRecord(instTeachingRecord : TeachingRecord, recordId :
        String) {
        try! realm.write {
            instTeachingRecord.recordId = recordId
        }
    }
    
    class func deleteAllInstructorTeachingRecords() {
        for instRecord in getAllInstructorTeachingRecords() {
            try! realm.write {
                realm.delete(instRecord)
            }
        }
    }
    
    class func deleteTeachingRecord(record: TeachingRecord) {
        try! realm.write {
            realm.delete(record)
        }
    }
    
    class func addOrUpdateTeachingRecord(record: TeachingRecord) {
        let foundRecordOpt = realm.objects(TeachingRecord).filter("recordId = '\(record.recordId)'").first
        if foundRecordOpt != nil {
            
        } else {
            try! realm.write {
                realm.add(record)
            }
        }
    }
    
}