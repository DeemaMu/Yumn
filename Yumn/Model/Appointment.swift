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
        //        self.appointments = appointments
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
    var confirmed: Bool = false
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
}

class BloodAppointment: Appointment {
    var donors: Int?
    
    init(appointments: [DAppointment], type: String, startTime: Date, endTime: Date,
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

class AppointmentVM: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var organAppointments = [OrganAppointment]()
    @Published var filteredAppointments: [OrganAppointment] = [OrganAppointment]()
    @Published var added = true
    @Published var appointmentsWithin = [DAppointment]()
    //    var thereIS = false
    
    init(){
        //        self.fetchOrganAppointments()
        self.fetchOrganAppointments()
        self.filteringAppointments()
    }
    
    let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("appointments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> Appointment in
                
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                
                if (type == "blood"){
                    let aptDuration = 30.0
                    let donors = data["donors"] as? Int ?? 0
                    
                    return BloodAppointment(appointments: appointments, type: type, startTime: startTime, endTime: endTime,
                                            aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, donors: donors)
                }
                else {
                    let organ = data["organ"] as? String ?? ""
                    let aptDuration = 60.0
                    var apt = OrganAppointment(type: type, startTime: startTime, endTime: endTime,
                                               aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
                    apt.appointments = appointments
                    return apt
                }
            }
        }
        
        //        db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
        //            guard let documents = querySnapshot?.documents else {
        //                print("no documents")
        //                return
        //            }
        //
        //            self.appointments = documents.map { (queryDocumentSnapshot) -> OrganAppointment in
        //                let data = queryDocumentSnapshot.data()
        //                let type = data["type"] as? String ?? ""
        //                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
        //
        //                let stamp1 = data["start_time"] as? Timestamp
        //                let startTime = stamp1!.dateValue()
        //
        //                let stamp2 = data["end_time"] as? Timestamp
        //                let endTime = stamp2!.dateValue()
        //
        //                let stamp3 = data["date"] as? Timestamp
        //                let aptDate = stamp3?.dateValue()
        //
        //                let hospital = data["hospital"] as? String ?? ""
        //                let aptDuration = 60.0
        //                let organ = data["organ"] as? String ?? ""
        //
        //                return OrganAppointment(appointments: appointments, type: type, startTime: startTime, endTime: endTime,
        //                                   aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
        //            }
        //        }
        
        
    }
    
    func fetchAppointmentsData(doc: QueryDocumentSnapshot) -> [DAppointment] {
        let docID = doc.documentID
        
        db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointmentsWithin = documents.map { (queryDocumentSnapshot) -> DAppointment in
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                let donor = data["donor"] as? String ?? ""
                let hName = data["hospital"] as? String ?? ""
                let confirmed = data["confirmed"] as? Bool ?? false
                let booked = data["booked"] as? Bool ?? false
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                return DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
            }
        }
        
        
        return self.appointmentsWithin
    }
    
    func fetchAppointmentsData2(docID: String) -> [DAppointment] {
        db.collection("appointments").document(docID).collection("appointments").whereField("booked", in: [false]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointmentsWithin = documents.map { (queryDocumentSnapshot) -> DAppointment in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let type = data["type"] as? String ?? ""
                let donor = data["donor"] as? String ?? ""
                let hName = data["hospital"] as? String ?? ""
                let confirmed = data["confirmed"] as? Bool ?? false
                let booked = data["booked"] as? Bool ?? false
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                var apt = DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
                apt.docID = id
                return apt
            }
        }
        
        
        return self.appointmentsWithin
    }
    
    
    func addData(apt: BloodAppointment) {
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 30
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
    
    func addDataOrgan(apt: OrganAppointment) {
        // Add doc to collection
        let newDoc = db.collection("appointments").document()
        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 60
                        , "organ": apt.organ ]) { error in
            
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
    
    
    func fetchOrganAppointments() {
        db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> OrganAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
//                let docID = queryDocumentSnapshot.documentID
                
                let appointments: [DAppointment] = self.fetchAppointmentsData(doc: queryDocumentSnapshot)
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                let organ = data["organ"] as? String ?? ""
                print("\(organ)")
                let aptDuration = 60.0
                
                let apt = OrganAppointment(type: type, startTime: startTime, endTime: endTime,
                                           aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
                apt.docID = queryDocumentSnapshot.documentID
                apt.appointments?.append(appointments[0])
                
                //                if(!apt.appointments!.isEmpty){
                //                    print("document3333")
                //
                //                }
                
                if((hospital == Constants.selected.selectedOrgan.hospital) && (organ == Constants.selected.selectedOrgan.organ)){
                    self.organAppointments.append(apt)
                }
                return apt
                
            }
            
        }
        
    }
    
    //    var storedAppointments: [OrganAppointment] =
    //    [
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //    ]
    
    @Published var currentDay: Date = Date()
    
    
    func filteringAppointments() -> [OrganAppointment] {
        let calender = Calendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if(!self.organAppointments.isEmpty){
                
                var filtered: [OrganAppointment] = self.organAppointments.filter {
                    return calender.isDate($0.aptDate, inSameDayAs: self.currentDay)
                }
                
                if(self.organAppointments.first?.appointments != nil){
                    filtered = filtered.filter {
                        return !(($0.appointments?.first?.booked)!)
                    }}
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.filteredAppointments = filtered
                    }
                }
            }
            
        }
        return self.filteredAppointments
    }
    
//    func filtering2weeksAppointments() -> Bool {
//        let calender = Calendar.current
//        var currentWeek: [Date] = []
//
//        // MARK: Curent day
//        let currentDay: Date = Date()
//
//        //        let today = Date()
//        //        let week = calender.dateInterval(of: .weekOfMonth, for: today)
//
//        //        let firstWeekDay = week?.start
//
//        (0...14).forEach {
//            day in
//
//            if let weekday = calender.date(byAdding: .day, value: day, to: currentDay) {
//                currentWeek.append(weekday)
//            }
//
//        }
//
//
//        if(!self.organAppointments.isEmpty){
//
//            var filtered = [OrganAppointment]()
//
//            if(self.organAppointments.first?.appointments != nil){
//
//                filtered = self.organAppointments.filter {
//                    return !(($0.appointments?.first?.booked)!)
//                }
//
//                if(!filtered.isEmpty){
//                    for day in currentWeek {
//                        for apt in filtered {
//                            if (calender.isDate(apt.aptDate, inSameDayAs: day)){
//                                return true
//                            }
//                        }
//                    }
//                }
//            }
//
//
//        }
//        return false
//
//
//    }
    
    
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

