import Foundation
import Firebase
import SwiftUI
import Combine

class BloodAppointmentM: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var bloodAppointments = [BloodAppointment]()
    @Published var filteredAppointments: [BloodAppointment] = [BloodAppointment]()
    @Published var added = true
    @Published var back = false
    @Published var miniAppointments = [String: [DAppointment]]()
    @Published var appointmentsWithin = [DAppointment]()
    var BloodApppointmentsCancellable: AnyCancellable?
    let db = Firestore.firestore()
    @Published var currentDay: Date = Date()

    
    init() {
        self.fetchBloodAppointments()
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
                let confirmed = data["confirmed"] as? String ?? ""
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
    
    func fetchBloodAppointmentsData(docID: String) -> Future<[String: [DAppointment]], Error> {
        var appointments = [DAppointment]()
        
        
        return Future<[String: [DAppointment]], Error> { promise in
            
            DispatchQueue.main.async {
                
                self.db.collection("appointments").document(docID).collection("appointments").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("no documents")
                        return
                    }
                    
                    appointments = documents.map { (queryDocumentSnapshot) -> DAppointment in
                        let data = queryDocumentSnapshot.data()
                        let id = queryDocumentSnapshot.documentID
                        let type = data["type"] as? String ?? ""
                        let donor = data["donor"] as? String ?? ""
                        let hName = data["hospital"] as? String ?? ""
                        let confirmed = data["confirmed"] as? String ?? ""
                        let booked = data["booked"] as? Bool ?? false
                        
                        let stamp1 = data["start_time"] as? Timestamp ?? Timestamp()
                        let startTime = stamp1.dateValue()
                        
                        let stamp2 = data["end_time"] as? Timestamp ?? Timestamp()
                        let endTime = stamp2.dateValue()
                        
                        var apt = DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
                        apt.docID = id
                        return apt
                    }
                    
                    if(!appointments.isEmpty) {
                        self.miniAppointments.updateValue(appointments, forKey: docID)
                        promise(.success(self.miniAppointments))
                    } else {
                        print("fail")
                    }
                }
                
            }
            
            
        }
    }
    
    func fetchBloodAppointments() {
        
        self.bloodAppointments.removeAll()
        var dAppointments = [DAppointment]()
        
        db.collection("appointments").whereField("type", in: ["blood"]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> BloodAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                let bookedApts = data["bookedAppointments"] as? [String] ?? [String]()
                let aptDuration = 60.0
                
                self.BloodApppointmentsCancellable = self.fetchBloodAppointmentsData(docID: queryDocumentSnapshot.documentID).receive(on: DispatchQueue.main
                ).sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { appointments in
                    if(!appointments.isEmpty){
                        self.back = true
                        dAppointments = appointments[queryDocumentSnapshot.documentID]!
                    }
                })
                
                let docId = queryDocumentSnapshot.documentID
                
                let apt = BloodAppointment(appointments: dAppointments, type: type, startTime: startTime, endTime: endTime,
                                           aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, donors: 3, mainDocID: docId)
                apt.docID = queryDocumentSnapshot.documentID
                apt.bookedAppointments = bookedApts
                
                if((hospital == Constants.selected.selectedOrgan.hospital)){
                    self.bloodAppointments.append(apt)
                }
                return apt
                
            }
            
        }
            
    }
    
    func filteringAppointments() -> [BloodAppointment] {
        let calender = Calendar.current
        var dappointments = [String: [DAppointment]]()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if(!self.bloodAppointments.isEmpty){
                
                var filtered: [BloodAppointment] = self.bloodAppointments.filter {
                    return calender.isDate($0.aptDate, inSameDayAs: self.currentDay)
                }
                
//                DispatchQueue.main.async {
//                self.miniAppointments.removeAll()
//                for filter in filtered {
//                        self.BloodApppointmentsCancellable = self.fetchBloodAppointmentsData(docID: filter.docID).receive(on: DispatchQueue.main
//                        ).sink(receiveCompletion: { completion in
//                            switch completion {
//                            case .finished:
//                                print("finished")
//                            case .failure(let error):
//                                print(error)
//                            }
//                        }, receiveValue: { appointments in
//                            if(!appointments.isEmpty){
//                                dappointments = appointments
//                            }
//                        })
//                    }
//                }
                
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.filteredAppointments = filtered
//                        self.miniAppointments = dappointments
                    }
                }
            }
            
        }
        return self.filteredAppointments
    }
    
    
}
