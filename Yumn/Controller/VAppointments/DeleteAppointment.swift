//
//  deleteAppointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 30/04/2022.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct deleteAppointment: View {
    let config: Configuration
    let appointment: retrievedAppointment
    let userID = Auth.auth().currentUser!.uid
    let controllerType: Int
//    let userID = ""
    
    let db = Firestore.firestore()
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment: .center, spacing: 30){
                Text("تأكيد عملية الحذف").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                

                VStack(spacing: 4){
                    Text("هل أنت متأكد من رغبتك في").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(textGray).fontWeight(.semibold)
                    HStack(){
                        Text("حذف الموعد؟").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).fontWeight(.semibold)
                    }
                }.padding(.top, 5)
                                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                        if(controllerType == 1){
                            let x =
                            config.hostingController?.parent as! VViewAppointmentsVC
                            x.cancelDelete()
                        } else {
                            let x =
                            config.hostingController?.parent as! futureAppointmensVC
                            x.cancelDelete()
                        }
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
                        if(appointment.type == "organ"){
                            if(self.DeleteFromAppointment()){
                                if(self.DeleteFromUser()){
                                    if(self.DeleteFromInnerAppointment()){
                                        if(controllerType == 1){
                                            Constants.selected.deleted = true
                                            let x =
                                            config.hostingController?.parent as! VViewAppointmentsVC
                                            x.confirmDelete()
                                        } else {
                                            let x =
                                            config.hostingController?.parent as! futureAppointmensVC
                                            x.confirmDelete()
                                            //                            x.cancel()
                                        }
                                    }
                                }
                            }
                        }
                        if(appointment.type == "blood"){
                            if(self.DeleteFromAppointment()){
                                if(self.DeleteFromUser()){
                                    if(self.DeleteFromInnerAppointment()){
                                        if(controllerType == 1){
                                            Constants.selected.deleted = true
                                            let x =
                                            config.hostingController?.parent as! VViewAppointmentsVC
                                            x.cancelDelete()
                                        } else {
                                            let x =
                                            config.hostingController?.parent as! futureAppointmensVC
                                            x.cancelDelete()
                                            //                            x.cancel()
                                        }
                                    }
                                }
                            }
                        }
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
        }
        
    }
    
    func DeleteFromInnerAppointment() -> Bool {
        var success = true
        
        db.collection("appointments").document(appointment.mainAppointmentID!).collection("appointments").document(appointment.appointmentID!).setData(["booked":false, "donor": ""], merge: true) { error in
            
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
        
        var doc = db.collection("appointments").document(appointment.mainAppointmentID!)
        
        doc.updateData(["bookedAppointments": FieldValue.arrayRemove([appointment.appointmentID])]) { error in
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
        
        db.collection("volunteer").document(userID).collection("organAppointments").document(appointment.appointmentID!).delete() { error in
            
            if error == nil {
                success = true
            } else {
                print("\(String(describing: error))")
                success = false
            }
        }
        return success
    }
}


struct deleteAppointment_Previews: PreviewProvider {
    static var previews: some View {
        deleteAppointment(config: Configuration(), appointment: retrievedAppointment(), controllerType: 1 )
    }
}
