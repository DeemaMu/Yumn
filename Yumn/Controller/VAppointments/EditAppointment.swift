//
//  editAppointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 29/04/2022.
//

import SwiftUI
import FirebaseAuth
import Firebase
import Combine

struct editAppointment: View {
    let config: Configuration
    let appointment: retrievedAppointment
//    let userID = Auth.auth().currentUser!.uid
    let controllerType: Int
    
    @State var hospitalCancellable: AnyCancellable?
    
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
                        if(appointment.type == "organ"){
                        Constants.selected.selectedOrgan.organ = self.appointment.organ!
                        }

                        if(controllerType == 1) {
                        let x = config.hostingController?.parent as! VViewAppointmentsVC
                            if(appointment.type == "organ"){
                                x.bookAppointment()
                            }
                            if(appointment.type == "blood"){
                                self.hospitalCancellable = fetchHospital().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("finished")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }, receiveValue: { Location in
                                    if(Location != nil){
                                        Constants.selected.selectedOrgan.hospital = self.appointment.hospitalID!
                                        Constants.selected.selectedHospital = Location
                                        x.bookBloodAppointment()
                                    } else {
                                        print("failed")
                                    }
                                })
                            }
                        } else {
                            //MARK: FROM FUTURE
                            let x = config.hostingController?.parent as! futureAppointmensVC
                            if(appointment.type == "organ"){
                                x.bookAppointment()
                            }
                            if(appointment.type == "blood"){
                                self.hospitalCancellable = fetchHospital().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("finished")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }, receiveValue: { Location in
                                    if(Location != nil){
                                        Constants.selected.selectedOrgan.hospital = self.appointment.hospitalID!
                                        Constants.selected.selectedHospital = Location
                                        x.bookBloodAppointment()
                                    } else {
                                        print("failed")
                                    }
                                })
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
    
    func fetchHospital() -> Future<Location, Error> {
        return Future<Location, Error> { promise in
            DispatchQueue.main.async {
                
                let doc = db.collection("hospitalsInformation").document(self.appointment.hospitalID!)
                
                doc.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        print("Document does not exist")
                        return
                    }
                    if (error == nil) {
                        print("here")
                        let doc = document.data()
                        let latitude:Double = doc!["latitude"] as! Double
                        let longitude:Double = doc!["longitude"] as! Double
                        let name: String = doc?["name"] as! String
                        let city: String = doc?["city"] as! String
                        let area: String = doc?["area"] as! String
                        let docID = document.documentID
                        var hospital = Location(name: name, lat: latitude, long: longitude, city: city, area: area)
                        hospital.docID = docID
                        
                        promise(.success(hospital))
                    } else {
                        promise(.failure(error!))
                    }
                   
                }
            }
        }
    }
    
}


struct editAppointment_Previews: PreviewProvider {
    static var previews: some View {
        editAppointment(config: Configuration(), appointment: retrievedAppointment(), controllerType: 1)
    }
}
