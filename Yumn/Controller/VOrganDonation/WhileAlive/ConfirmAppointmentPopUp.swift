//
//  ConfirmAppointmentPopUp.swift
//  Yumn
//
//  Created by Rawan Mohammed on 26/04/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

struct ConfirmAppointmentPopUp: View {
    let config: Configuration
    let appointment: OrganAppointment
    let exact: DAppointment
    let userID = Auth.auth().currentUser!.uid
    
    let db = Firestore.firestore()
    
    let mainDocID = Constants.selected.mainDoc
    let exactID = Constants.selected.exactDoc
    
    @State var listener: ListenerRegistration?
    @State var updateDataCancellable : AnyCancellable?
    @State var addToUserCancellable : AnyCancellable?
    @State var addToArrayCancellable : AnyCancellable?
    @State var deleteFromArrayCancellable : AnyCancellable?
    @State var deleteFromUserCancellable : AnyCancellable?
    @State var updateDocumentCancellable : AnyCancellable?
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    @State var hospitalName = ""
    @State var hospitalLocation = ""
    
    @State var appointmentsTemp:[DAppointment]?
    @State var docID:[String]?
    
    var weekdaysAR: [String:String] =
    [
        "Sun": "الأحد",
        "Mon": "الأثنين",
        "Tue": "الثلاثاء",
        "Wed": "الاربعاء",
        "Thu":"الخميس",
        "Fri":"الجمعة",
        "Sat":"السبت"
    ]
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                Text(("تأكيد الموعد")).font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                
                VStack(spacing: 15){
                    Text("الموقع:").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("\(hospitalName)").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                VStack(spacing: 15){
                    Text("التاريخ").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("\(self.convertToArabic(date: appointment.aptDate))").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                VStack(spacing: 15){
                    Text("التوقيت:").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("\(appointment.startTime.getFormattedDate(format: "HH:mm")) - \(appointment.endTime.getFormattedDate(format: "HH:mm")) ").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                        let x =
                        config.hostingController?.parent as! Alive4thVC
                        x.cancel()
                    }
                    ) {
                        Text("إلغاء").font(Font.custom("Tajawal", size: 16))
                            .foregroundColor(mainDark)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 25,
                            style: .continuous
                        )
                            .fill(bgWhite)
                    )
                    .frame(width: 100, height: 30, alignment: .center)
                    
                    
                    Button(action: {
                        
                        self.updateDataCancellable = saveData().receive(on: DispatchQueue.main
                        ).sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("finished")
                            case .failure(let error):
                                print(error)
                            }
                        }, receiveValue: { success in
                            print(success)
                            if(success){
                                if(Constants.selected.edit){
                                    self.deleteDoc()
                                }
                                self.addToArray()
                            } else {
                                let x =
                                config.hostingController?.parent as! Alive4thVC
                                x.fail()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    listener?.remove()
                                }
                                print("failed")
                            }
                        })
                        
                        
                        //                        self.updateData { succuss in
                        //                            if succuss {
                        //                                print("lets goooo")
                        //                                if(Constants.selected.edit){
                        //                                    self.deleteDoc()
                        //                                }
                        //                                else {
                        //                                    let x =
                        //                                    config.hostingController?.parent as! Alive4thVC
                        //                                    x.confirm()
                        //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        //                                        listener?.remove()
                        //                                    }
                        //                                }
                        //                            }else{
                        //                                let x =
                        //                                config.hostingController?.parent as! Alive4thVC
                        //                                x.fail()
                        //                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        //                                    listener?.remove()
                        //                                }
                        //                                print("failed")
                        //                            }
                        //                        }
                        
                    }) {
                        Text("تأكيد").font(Font.custom("Tajawal", size: 16))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 25,
                            style: .continuous
                        )
                            .fill(mainDark)
                    )
                    .frame(width: 100, height: 30, alignment: .center)
                    
                    
                }
                
            }.padding(.vertical)
                .padding(.horizontal, 25)
        }.onAppear {
            self.getHospitalName()
        }
    }
    
    func deleteDoc(){
        DeleteFromInnerAppointment()
    }
    
    // Constants.selected.mainDoc
    // Constants.selected.exactDoc
    
    func DeleteFromInnerAppointment() {
        
        self.updateDocumentCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                let doc = db.collection("appointments").document(self.mainDocID).collection("appointments").document(self.exactID)
                
                doc.getDocument {  (document, error) in
                    
                    if ((document?.exists) != nil) {
                        doc.setData(["booked":false, "donor": ""], merge: true) { error in
                            if error == nil {
                                promise(.success(true))
                            } else {
                                print("\(String(describing: error))")
                                promise(.failure(error!))
                            }
                        }
                    } else {
                        print("Document does not exist")
                        promise(.failure(error!))
                    }
                }
            }
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                self.DeleteFromUser()
            } else {
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
    }
    
    func removeFromInnerAppointment(appointmentID: String, mainAppointmentId: String) {
        
        self.updateDocumentCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                let doc = db.collection("appointments").document(mainAppointmentId).collection("appointments").document(appointmentID)
                
                doc.getDocument {  (document, error) in
                    
                    if ((document?.exists) != nil) {
                        doc.setData(["booked":false, "donor": ""], merge: true) { error in
                            if error == nil {
                                promise(.success(true))
                            } else {
                                print("\(String(describing: error))")
                                promise(.failure(error!))
                            }
                        }
                    } else {
                        print("Document does not exist")
                        promise(.failure(error!))
                    }
                }
            }
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                self.addToArray()
            } else {
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
    }
    
    
    
    func DeleteFromAppointment(mainAppointmentId: String) {
        
        self.deleteFromArrayCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                let doc = db.collection("appointments").document(mainAppointmentId)
                
                doc.updateData(["bookedAppointments": FieldValue.arrayRemove([Constants.selected.exactDoc])]) { error in
                    if (error == nil) {
                        promise(.success(true))
                    } else {
                        promise(.failure(error!))
                    }
                }
            }
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                let x = config.hostingController?.parent as! Alive4thVC
                x.confirm()
            } else {
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
        
    }
    
    
    
    func DeleteFromUser() {
        self.deleteFromUserCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                let doc = db.collection("volunteer").document(userID).collection("organAppointments").document(exactID)
                
                doc.getDocument {  (document, error) in
                    
                    if ((document?.exists) != nil) {
                        doc.delete() { error in
                            
                            if error == nil {
                                promise(.success(true))
                            } else {
                                print("\(String(describing: error))")
                                promise(.failure(error!))
                            }
                        }
                    } else {
                        print("Document does not exist")
                        promise(.failure(error!))
                    }
                }
            }
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                self.DeleteFromAppointment(mainAppointmentId: mainDocID)
            } else {
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
    }
    
    // Saving data to database
    // first, we update appointment state
    func saveData() -> Future<Bool, Error>{
        
        return Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                
                // Retrieve first Document
                self.listener = db.collection("appointments").document(appointment.docID).collection("appointments").limit(to: 1).addSnapshotListener { QuerySnapshot, Error in
                    
                    guard let documents = QuerySnapshot?.documents else {
                        print("no documents")
                        promise(.failure(Error!))
                        return
                    }
                    
                    // Save document id
                    self.docID = documents.map { (queryDocumentSnapshot) -> String in
                        let docID = queryDocumentSnapshot.documentID
                        return docID
                    }
                    
                    // Uodate appointment status to booked and assign user as donor
                    db.collection("appointments").document(appointment.docID).collection("appointments").document(docID![0]).setData(["booked":true, "donor": userID], merge: true) { error in
                        
                        if error == nil {
                            if(self.appointment.bookedAppointments == nil){
                                self.appointment.bookedAppointments = [String]()
                                
                            }
                            print("exact document Id: \(exact.docID)")
                            self.appointment.bookedAppointments?.append(exact.docID)
                            promise(.success(true))
                        } else {
                            print("\(String(describing: error))")
                            promise(.failure(error!))
                        }
                    }
                }
            }
        }
    }
    
    // Saving data to database
    // second, we add appointment to array
    func addToArray() {
        
        addToArrayCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                
                let doc = db.collection("appointments").document(self.appointment.docID)
                
                doc.updateData(["bookedAppointments": FieldValue.arrayUnion([docID![0]])]) { error in
                    if (error == nil) {
                        promise(.success(true))
                    } else {
                        
                        promise(.failure(error!))
                    }
                }
            }
        }.receive(on: DispatchQueue.main
        ).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                addToUser()
            } else {
                self.removeFromInnerAppointment(appointmentID: self.exact.docID, mainAppointmentId: self.appointment.docID)
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
    }
    
    // Saving data to database
    // last, we add appointment to user
    func addToUser() {
        
        addToUserCancellable = Future<Bool, Error> { promise in
            DispatchQueue.main.async {
                
                let newDoc = db.collection("volunteer").document(userID).collection("organAppointments").document(exact.docID)
                
                newDoc.setData(["type": appointment.type,"hospital": appointment.hospital, "start_time": appointment.startTime,
                                "end_time": appointment.endTime, "date": appointment.aptDate, "appointment_duration": 60
                                , "docID": exact.docID, "mainDocId": appointment.docID, "hospital_name": self.hospitalName, "organ": appointment.organ, "location": self.hospitalLocation]) { error in
                    
                    if (error == nil){
                        promise(.success(true))
                    } else {
                        print(error!)
                        promise(.failure(error!))
                    }
                }
            }
        }.receive(on: DispatchQueue.main
        ).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { success in
            print(success)
            if(success){
                if(Constants.selected.edit){
                    listener?.remove()
                    self.deleteDoc()
                }
                else {
                    let x =
                    config.hostingController?.parent as! Alive4thVC
                    x.confirm()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        listener?.remove()
                    }
                }
                
            } else {
                self.removeFromInnerAppointment(appointmentID: self.exact.docID, mainAppointmentId: self.appointment.docID)
                self.DeleteFromAppointment(mainAppointmentId: self.appointment.docID)
                let x =
                config.hostingController?.parent as! Alive4thVC
                x.fail()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    listener?.remove()
                }
                print("failed")
            }
        })
    }
    
    func convertToArabic(date: Date) -> String {
        let formatter = DateFormatter()
        
        //        formatter.dateFormat = "EEEE, d, MMMM, yyyy HH:mm a"
        formatter.dateFormat = "EEEE, d, MMMM, yyyy"
        formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        
        return formatter.string(from: date)
        
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func getHospitalName() -> String {
        //        var name = ""
        print(self.appointment.hospital)
        let doc = db.collection("hospitalsInformation").document(appointment.hospital)
        
        doc.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            print("here")
            let dataDescription = document.data()
            self.hospitalName = dataDescription?["name"] as! String
            let city = dataDescription?["city"] as! String
            let area = dataDescription?["area"] as! String
            self.hospitalLocation = city + " - " + area
        }
        
        return hospitalName
    }
    
    //    func DeleteFromUser() -> Bool {
    //        var success = true
    //
    //        let doc = db.collection("volunteer").document(userID).collection("organAppointments").document(exactID)
    //
    //        doc.getDocument {  (document, error) in
    //
    //            if ((document?.exists) != nil) {
    //                doc.delete()
    //
    //           } else {
    //              print("Document does not exist")
    //           }
    //
    //
    //        }
    ////            .delete() { error in
    ////
    ////            if error == nil {
    ////                success = true
    ////            } else {
    ////                print("\(String(describing: error))")
    ////                success = false
    ////            }
    ////        }
    //        return success
    //    }
    //
    //    func DeleteFromAppointment(mainAppointmentId: String) -> Bool {
    //        var success = true
    //
    //        let doc = db.collection("appointments").document(mainAppointmentId)
    //
    //        doc.updateData(["bookedAppointments": FieldValue.arrayRemove([Constants.selected.exactDoc])]) { error in
    //            if (error == nil) {
    //                success = true
    //            } else {
    //                print(error!)
    //                success = false
    //            }
    //        }
    //        return success
    //    }
    //    func DeleteFromInnerAppointment(appointmentID: String, mainAppointmentId: String) -> Bool {
    //        var success = true
    //
    //        db.collection("appointments").document(mainAppointmentId).collection("appointments").document(appointmentID).setData(["booked":false, "donor": ""], merge: true) { error in
    //
    //            if error == nil {
    //                success = true
    //            } else {
    //                print("\(String(describing: error))")
    //                success = false
    //            }
    //        }
    //
    //        return success
    //    }
}

//struct ConfirmAppointmentPopUp_Previews: PreviewProvider {
//    static var apt = OrganAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: "المملكة", aptDuration: 60, organ: Constants.selected.selectedOrgan.organ)
//    
//    
//    static var previews: some View {
//        ConfirmAppointmentPopUp(config: Configuration(), appointment: apt, exact: DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false))
//    }
//}


