//
//  ConfirmAppointmentPopUp.swift
//  Yumn
//
//  Created by Rawan Mohammed on 26/04/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ConfirmAppointmentPopUp: View {
    let config: Configuration
    let appointment: OrganAppointment
    let exact: DAppointment
    let userID = Auth.auth().currentUser!.uid
    
    let db = Firestore.firestore()
    
    @State var listener: ListenerRegistration?
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    @State var hospitalName = ""
    @State var hospitalLocation = ""
    
    @State var appointmentsTemp:[DAppointment]?
    @State var docID:String?
    
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
                        
                        self.updateData { succuss in
                            if succuss {
                                print("lets goooo")
                                if(Constants.selected.edit){
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
                            }else{
                                let x =
                                config.hostingController?.parent as! Alive4thVC
                                x.fail()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    listener?.remove()
                                }
                                print("failed")
                            }
                        }
                        
                        //                        if(self.updateData()){
                        //                            if(self.addToArray()){
                        //                                if(self.addToUser()){
                        //                                    if(!Constants.selected.edit){
                        //                                        print("lets goooo")
                        //                                        let x =
                        //                                        config.hostingController?.parent as! Alive4thVC
                        //                                        x.confirm()
                        //                                    } else {
                        //
                        //                                    }
                        //                                }  else {
                        //                                    print("fail22222")
                        //                                }
                        //                            }
                        //                            else {
                        //                                print("fail1111")
                        //                            }
                        //                        }
                        //                        else {
                        //                            print("fail3333")
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
        
        if(self.DeleteFromAppointment()){
            if(self.DeleteFromUser()){
                if(self.DeleteFromInnerAppointment()){
                    let x = config.hostingController?.parent as! Alive4thVC
                    x.confirm()
                
                }
            }
        }
        
    }
    
    // Constants.selected.mainDoc
    // Constants.selected.exactDoc
    
    func DeleteFromInnerAppointment() -> Bool {
        var success = true
        
        db.collection("appointments").document(Constants.selected.mainDoc).collection("appointments").document(Constants.selected.exactDoc).setData(["booked":false, "donor": ""], merge: true) { error in
            
            if error == nil {
                success = true
            } else {
                print("\(String(describing: error))")
                success = false
            }
        }
        
        return success
    }
    
    func DeleteFromAppointment() -> Bool {
        var success = true
        
        var doc = db.collection("appointments").document(Constants.selected.mainDoc)
        
        doc.updateData(["bookedAppointments": FieldValue.arrayRemove([Constants.selected.exactDoc])]) { error in
            if (error == nil) {
                success = true
            } else {
                print(error!)
                success = false
            }
        }
        return success
    }
    
    func DeleteFromUser() -> Bool {
        var success = true
        
        db.collection("volunteer").document(userID).collection("organAppointments").document(Constants.selected.exactDoc).delete() { error in
            
            if error == nil {
                success = true
            } else {
                print("\(String(describing: error))")
                success = false
            }
        }
        return success
    }
    
    
    func updateData(completion: (Bool) -> () ){
        var success = true
        
        self.listener = db.collection("appointments").document(appointment.docID).collection("appointments").limit(to: 1).addSnapshotListener { QuerySnapshot, Error in
            
            guard let documents = QuerySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointmentsTemp = documents.map { (queryDocumentSnapshot) -> DAppointment in
                
                let data = queryDocumentSnapshot.data()
                let docID = queryDocumentSnapshot.documentID
                let donor: String = "-1"
                let hName: String = ""
                let confirmed: Bool = false
                let booked: Bool = false
                
                let type = data["type"] as? String ?? ""
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                let hospital = data["hospital"] as? String ?? ""
                
                
                let organ = data["organ"] as? String ?? ""
                let aptDuration = 60.0
                var apt = DAppointment(type: "organ")
                apt.startTime = startTime
                apt.endTime = endTime
                apt.hName = hospital
                apt.docID = docID
                self.docID = docID
                return apt
            }
            
            db.collection("appointments").document(appointment.docID).collection("appointments").document(docID!).setData(["booked":true, "donor": userID], merge: true) { error in
                
                if error == nil {
                    if(appointment.bookedAppointments == nil){
                        appointment.bookedAppointments = [String]()
                        
                    }
                    print("heerreeee44444 \(exact.docID)")
                    appointment.bookedAppointments?.append(exact.docID)
                    success = true && success
                } else {
                    print("\(String(describing: error))")
                    success = false
                }
            }
            
            var doc = db.collection("appointments").document(appointment.docID)
            
            doc.updateData(["bookedAppointments": FieldValue.arrayUnion([docID!])]) { error in
                if (error == nil) {
                    success = true && success
                } else {
                    print(error!)
                    success = false
                }
            }
            
            
            // add to user
            let newDoc = db.collection("volunteer").document(userID).collection("organAppointments").document(exact.docID)
            
            newDoc.setData(["type": appointment.type,"hospital": appointment.hospital, "start_time": appointment.startTime,
                            "end_time": appointment.endTime, "date": appointment.aptDate, "appointment_duration": 60
                            , "docID": exact.docID, "mainDocId": appointment.docID, "hospital_name": self.hospitalName, "organ": appointment.organ, "location": self.hospitalLocation]) { error in
                
                if (error == nil){
                    success = true && success
                } else {
                    print(error!)
                    success = false
                }
            }
            
        }
        
        completion(success)
    }
    
    
    func addToArray(completion: (Bool) -> () ){
        var success = true
        
        var doc = db.collection("appointments").document(appointment.docID)
        
        doc.updateData(["bookedAppointments": FieldValue.arrayUnion([docID!])]) { error in
            if (error == nil) {
                success = true
            } else {
                print(error!)
                success = false
            }
        }
        
        //            .setData(["bookedAppointments":appointment.bookedAppointments], merge: true) { error in
        //
        //            if error == nil {
        //                success = true
        //            } else {
        //                success = false
        //            }
        //        }
        
        completion(success)
    }
    
    func addToUser(completion: (Bool) -> () ){
        var added = true
        let newDoc = db.collection("volunteer").document(userID).collection("organAppointments").document(exact.docID)
        
        newDoc.setData(["type": appointment.type,"hospital": appointment.hospital, "start_time": appointment.startTime,
                        "end_time": appointment.endTime, "date": appointment.aptDate, "appointment_duration": 60
                        , "docID": exact.docID, "mainDocId": appointment.docID, "hospital_name": self.hospitalName, "organ": appointment.organ, "location": self.hospitalLocation]) { error in
            
            if (error == nil){
                added = true
            } else {
                print(error!)
                added = false
            }
        }
        
        completion(added)
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
}

//struct ConfirmAppointmentPopUp_Previews: PreviewProvider {
//    static var apt = OrganAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: "المملكة", aptDuration: 60, organ: Constants.selected.selectedOrgan.organ)
//    
//    
//    static var previews: some View {
//        ConfirmAppointmentPopUp(config: Configuration(), appointment: apt, exact: DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false))
//    }
//}
