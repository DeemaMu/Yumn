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
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    
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
    
    //    var monthsAR: [String:String] =
    //    [
    //        "01": "الأحد",
    //        "Mon": "الأثنين",
    //        "Tue": "الثلاثاء",
    //        "Wed": "الاربعاء",
    //        "Thu":"الخميس",
    //        "Fri":"الجمعة",
    //        "Sat":"السبت"
    //    ]
    
    
    
    
    //    init(){
    //        appointment.appointments = [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                Text("تأكيد الموعد").font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                
                VStack(spacing: 15){
                    Text("الموقع:").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("\(appointment.hospital)").font(Font.custom("Tajawal", size: 14))
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
                        Text("\(exact.startTime.getFormattedDate(format: "HH:mm")) - \(exact.endTime.getFormattedDate(format: "HH:mm")) ").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                        var x =
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
                        if(self.updateData()){
                            print("lets goooo")
                            var x =
                            config.hostingController?.parent as! Alive4thVC
                            x.confirm()
                        } else {
                            print("fail")
                        }
                    }
                    ) {
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
        }
    }
    
    func updateData() -> Bool {
        var success = true
        
        db.collection("appointments").document(appointment.docID).collection("appointments").document(exact.docID).setData(["booked":true, "donor": userID], merge: true) { error in
            
            if error == nil {
                success = true
            } else {
                success = false
            }
        }
        
        return success
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
        var name = ""
        let doc = db.collection("hospitalsInformation").document(appointment.hospital)
        
        doc.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            let dataDescription = document.data()
            name = dataDescription?["name"] as! String
        }
        
        return name
    }
}

struct ConfirmAppointmentPopUp_Previews: PreviewProvider {
    static var apt = OrganAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: "المملكة", aptDuration: 60, organ: Constants.selected.selectedOrgan.organ)
    
    
    static var previews: some View {
        ConfirmAppointmentPopUp(config: Configuration(), appointment: apt, exact: DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false))
    }
}
