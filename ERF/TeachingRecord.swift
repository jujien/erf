//
//  TeachingRecord.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift

class TeachingRecord: Object {
    dynamic var code = ""
    dynamic var classCode = ""
    dynamic var roleCode = ""
    dynamic var date = NSDate()
    dynamic var recordId = ""
    dynamic var userName = ""
    dynamic var recordTime = ""
    
    class func create(code: String, classCode: String, roleCode: String, date: NSDate, recordId: String, userName: String, recordTime: String) -> TeachingRecord {
        let teachingRecord = TeachingRecord()
        teachingRecord.code = code
        teachingRecord.classCode = classCode
        teachingRecord.roleCode = roleCode
        teachingRecord.date = date
        teachingRecord.recordId = recordId
        teachingRecord.userName = userName
        teachingRecord.recordTime = recordTime
        return teachingRecord
    }
    
    class func groupByDate(teachingRecords: [TeachingRecord]) -> [TeachingRecordGroup] {
        var value: [TeachingRecordGroup] = []
        for teachingRecord in teachingRecords {
            let date = teachingRecord.date.string
            let group = value.filter({ (group) -> Bool in
                return group.dateString == date
            })
            if let group = group.first {
                group.teachingRecords?.append(teachingRecord)
            } else {
                value.append(TeachingRecordGroup(dateString: date, teachingRecords: [teachingRecord]))
            }
        }
        return value.sort({ (x, y) -> Bool in
            x.dateString > y.dateString
        })
    }
    
    var instructor : Instructor? {
        get {
            print(self.code)
            return Database.getInstructorByCode(self.code)
        }
    }
    
    var classTitle : String {
        get {
            return Class.getTitle(self.classCode)
        }
    }
    
    var roleTitle : String {
        get {
            return Role.getTitle(self.roleCode)
        }
    }
    
    var editable : Bool {
        get {
            if let user = Database.getUser() {
                if user.userName == self.userName {
                    return true
                }
            }
            return false
        }
    }
}