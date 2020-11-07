//
//  Duty.swift
//  Coronavoider
//
//  Created by Octavian Custura on 07/11/2020.
//

import Foundation


protocol Duty {
    var number: Int { get }
}


class Work: Duty {
    var number: Int
    var society: String
    var location: String
    var workPoint1: String?
    var workPoint2: String?
    
    init() {
        number = 1
        self.society = ""
        self.location = ""
    }
    init(society: String, location: String, workPoint1: String? = nil, workPoint2: String? = nil) {
        self.society = society
        self.location = location
        self.workPoint1 = workPoint1
        self.workPoint2 = workPoint2
        self.number = 1
    }
}

class MedicalAssistance: Duty {
    var number: Int
    init() {
        self.number = 2
    }
}

class MedsBuy: Duty {
    var number: Int
    init() {
        self.number = 3
    }
}

class Caretaking: Duty {
    var number: Int
    init() {
        self.number = 4
    }
}
class DeceasedPerson: Duty {
    var number: Int
    init() {
        self.number = 5
    }
}
