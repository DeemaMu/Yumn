//
//  Appointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import SwiftUI
import Firebase
//

class OrganAppointment: Appointment, Identifiable {
    var id = UUID().uuidString
    var organ: String = ""
    
    init(type: String, startTime: Date, endTime: Date,
         aptDate: Date, hospital: String, aptDuration: Double, organ: String) {
        super.init()
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.aptDate = aptDate
        self.hospital = hospital
        self.aptDuration = aptDuration
        self.organ = organ
    }
}


struct DAppointment: Identifiable {
    var id = UUID().uuidString
    var type: String
    var docID = ""
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(30 * 60)
    var donor: String = "-1"
    var hName: String = ""
    var confirmed: String = ""
    var booked: Bool = false
}

class Appointment {
    var appointments: [DAppointment]?
    var docID = ""
    var type: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
    var aptDate: Date = Date()
    var hospital: String = ""
    var aptDuration: Double = 0
    var bookedAppointments: [String]?
}

class BloodAppointment: Appointment {
    var donors: Int?
    
    init(type: String, startTime: Date, endTime: Date,
         aptDate: Date, hospital: String, aptDuration: Double, donors: Int) {
        super.init()
        self.appointments = appointments
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.aptDate = aptDate
        self.hospital = hospital
        self.aptDuration = aptDuration
        self.donors = donors
    }
}


func getSampleDate(offset: Int) -> Date{
    let calender = Calendar.current
    
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

//var appointments: [Appointment] =
//[
//    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 1), hospital: Constants.UserInfo.userID, donors: 4),
//    Appointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: -3), hospital: Constants.UserInfo.userID, donors: 6),
//    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 4), hospital: "center", donors: 7),
//    Appointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 1), hospital: Constants.UserInfo.userID, donors: 4),
//    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: -10), hospital: Constants.UserInfo.userID, donors: 2),
//
//]

