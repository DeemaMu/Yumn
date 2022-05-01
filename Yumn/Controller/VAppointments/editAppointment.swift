//
//  editAppointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 29/04/2022.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct editAppointment: View {
    let config: Configuration
    let appointment: retrievedAppointment
//    let userID = Auth.auth().currentUser!.uid
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
            VStack(alignment: .center, spacing: 30){
                Text("تأكيد عملية التعديل").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                

                VStack(spacing: 4){
                    Text("هل أنت متأكد من رغبتك في").font(Font.custom("Tajawal", size: 14))
                        .foregroundColor(textGray).fontWeight(.semibold)
                    HStack(){
                        Text("تعديل الموعد؟").font(Font.custom("Tajawal", size: 14))
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
                        
                        Constants.selected.edit = true
                        Constants.selected.mainDoc = self.appointment.mainAppointmentID!
                        Constants.selected.exactDoc = self.appointment.appointmentID!
                        Constants.selected.selectedOrgan.organ = self.appointment.organ!

                        if(controllerType == 1) {
                        let x = config.hostingController?.parent as! VViewAppointmentsVC
                            x.bookAppointment()
                        } else {
                            //MARK: FROM FUTURE
                            let x = config.hostingController?.parent as! futureAppointmensVC
                                x.bookAppointment()
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
    
}

struct editAppointment_Previews: PreviewProvider {
    static var previews: some View {
        editAppointment(config: Configuration(), appointment: retrievedAppointment(), controllerType: 1)
    }
}
