//
//  Appointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import SwiftUI
import Firebase
//
struct DAppointment: Identifiable {
    var id = UUID().uuidString
    var type: String
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(30 * 60)
    var donor: String = "-1"
    var hName: String = "mamlakah"
    var confirmed: Bool = false
    var booked: Bool = false
}

struct Appointment {
    var appointments: [DAppointment]?
    var type: String
    var startTime: Date
    var endTime: Date
    var aptDate: Date
    var hospital: String
    var aptDuration: Double?
    //    var totalDonors: Int
    var donors: Int
    //    var donorsList: [String]?
}

class AppointmentVM: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var added = true
    
    func addData(apt: Appointment) {
        let db = Firestore.firestore()
        
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": apt.aptDuration!
                        , "donors": apt.donors ]) { error in
            
            if (error == nil){
                
            } else {
                print(error!)
                self.added = false
            }
        }
        
        // add collection to doc
        
        for index in 0...(apt.appointments!.count - 1) {
            let miniApt = apt.appointments![index]
            newDoc.collection("appointments").addDocument(data: ["type": miniApt.type , "start_time": miniApt.startTime,
                                                                 "end_time": miniApt.endTime,  "donor": miniApt.donor
                                                                 , "confirmed": miniApt.confirmed, "booked": miniApt.booked,
                                                                 "hospital": miniApt.hName]) { error in
                if (error == nil){
                    
                } else {
                    print(error!)
                    self.added = false
                }
            }
        }
        
    } // end of addData
    
    func addDataOrgan(apt: Appointment) {
        let db = Firestore.firestore()
        
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 1
                        , "donors": apt.donors ]) { error in
            
            if (error == nil){
                
            } else {
                print(error!)
                self.added = false
            }
        }
        
        // add collection to doc
        
        for index in 0...(apt.appointments!.count - 1) {
            let miniApt = apt.appointments![index]
            newDoc.collection("appointments").addDocument(data: ["type": miniApt.type , "start_time": miniApt.startTime,
                                                                 "end_time": miniApt.endTime,  "donor": miniApt.donor
                                                                 , "confirmed": miniApt.confirmed, "booked": miniApt.booked,
                                                                 "hospital": miniApt.hName]) { error in
                if (error == nil){
                    
                } else {
                    print(error!)
                    self.added = false
                }
            }
        }
        
    } // end of addData

    
    
    
}

func getSampleDate(offset: Int) -> Date{
    let calender = Calendar.current
    
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var appointments: [Appointment] =
[
    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 1), hospital: "mamlakah", donors: 4),
    Appointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: -3), hospital: "mamlakah", donors: 6),
    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 4), hospital: "center", donors: 7),
    Appointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: 1), hospital: "mamlakah", donors: 4),
    Appointment(type: "blood", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), aptDate: getSampleDate(offset: -10), hospital: "mamlakah", donors: 2),
    
]

