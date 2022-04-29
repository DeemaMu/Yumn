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
    
    let db = Firestore.firestore()
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                Text("تأكيد الموعد").font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                
                VStack(spacing: 15){
                    Text("الموقع:").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("hi").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                VStack(spacing: 15){
                    Text("التاريخ").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("hiii").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                VStack(spacing: 15){
                    Text("التوقيت:").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(mainLight).fontWeight(.semibold).hTrailing()
                    HStack(){
                        Text("hi").font(Font.custom("Tajawal", size: 14))
                            .foregroundColor(textGray).hTrailing().padding(.trailing, 15)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                        if(controllerType == 1){
                        let x =
                        config.hostingController?.parent as! VViewAppointmentsVC
//                        x.cancel()
                        } else {
                            let x =
                            config.hostingController?.parent as! futureAppointmensVC
//                            x.cancel()
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
