//
//  TeachingRecordGroup.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation

class TeachingRecordGroup: NSObject {
    let dateString : String?
    var teachingRecords : [TeachingRecord]?
    
    init(dateString: String, teachingRecords: [TeachingRecord]) {
        self.dateString = dateString
        self.teachingRecords = teachingRecords
    }
}