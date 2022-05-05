//
//  AODHospitalList.swift
//  Yumn
//
//  Created by Rawan Mohammed on 25/04/2022.
//

import SwiftUI
import Firebase
import MapKit
import CoreLocation
import UIKit

struct AODHospitalList: View {
    
    let config: Configuration
    @ObservedObject var hVM = ODHospitals()
    
    
    @State var checked = false
    @State var checkedIndex = -1
    @State var showError = false
    @State var thereIs = false
    
    
    @State var controller: Alive3rdVC = Alive3rdVC()
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    
    
    @ObservedObject var appointmentsVM = OrgansVM()
    
    
    var body: some View {
        
        ZStack(){
            
            VStack(spacing: 20){
                HStack(){
                    Spacer()
                    Text("حجز موعد للفحص المبدئي").font(Font.custom("Tajawal", size: 16)).fontWeight(.bold)
                        .foregroundColor(mainDark)
                }
                .onChange(of: checked){ newValue in
                    //                self.selectAll()
                }
                .padding(.trailing)
                
                
                
                ScrollView(.vertical, showsIndicators: false){
                    ZStack {
                        VStack{
                            
                            // If there werent any organ donation available for the next two weeks
                            // display message
                            if(!thereIs){
                                Text("لا توجد مواعيد خلال الاسبوعين القادمة.").font(Font.custom("Tajawal", size: 16))
                                    .foregroundColor(lightGray).padding(.top, 100).multilineTextAlignment(.center)
                                Text("الرجاء المحاولة لاحقًا").font(Font.custom("Tajawal", size: 16))
                                    .foregroundColor(lightGray).padding(.top, 4).multilineTextAlignment(.center)
                            }
                            
                        }
                        // If there were, display each hospital
                        VStack(spacing: 20){
                            
                            ForEach(0..<hVM.odHospitals.count, id: \.self) { index in
                                card(hospital: hVM.odHospitals[index], index: index)
                            }
                        }.padding(.top, 10)
                    }
                }
                
                if(showError){
                    Text("الرجاء اختيار مستشفى لعرض المواعيد *").font(Font.custom("Tajawal", size: 15))
                        .foregroundColor(.red)
                }
            
                Button(action: {
                    // if the volunteer didnt select a hospital, display error
                    if(checkedIndex == -1){
                        showError = true
                    } else {
                        // if the volunteer they did select a hospital, procced to
                        // choosing an appointment
                        showError = false
                        Constants.selected.selectedOrgan.hospital = hVM.odHospitals[checkedIndex].hospitalID
                        let x =
                        config.hostingController?.parent as! Alive3rdVC
                        x.showAppointments()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            hVM.listener?.remove()
                        }
                    }
                }
                ) {
                    Text("متابعة").font(Font.custom("Tajawal", size: 20))
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
                .frame(width: 230, height: 59, alignment: .center)
            }.onAppear(){
                self.hVM.fetchData()
                self.hVM.fetchHospitalsInfo()
            }
            
        }.onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                hVM.listener?.remove()
            }
        }
    }
    
    
    @ViewBuilder
    func card(hospital: odHospital, index: Int) -> some View{
        let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
        let currentH = hospital.hospital
        
        HStack(){
            VStack(alignment: .leading){
                if(hospital.selected){
                    RadioButton2(matched: true)
                }
                if(!hospital.selected){
                    RadioButton2(matched: false)
                }
            }.padding(.leading, 20)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 20){
                Text("\(currentH!.name)").font(Font.custom("Tajawal", size: 17))
                    .foregroundColor(mainDark)
                Text("\(currentH!.area) - \(currentH!.city)").font(Font.custom("Tajawal", size: 12))
                    .foregroundColor(mainDark)
            }.frame(maxWidth: .infinity, alignment: .trailing)
                .frame(height: 90)
                .padding(10)
            
        }.onChange(of: checkedIndex){ newValue in
            if(newValue == index){
                hVM.odHospitals[index].selected = true
            } else {
                hVM.odHospitals[index].selected = false
            }
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(height: 90, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 6)
        .onTapGesture {
            if(checkedIndex == index){
                checkedIndex = -1
                showError = true
            } else {
                checkedIndex = index
                showError = false
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .onAppear {
            thereIs = true
        }
    }
    
}


struct odHospital: Identifiable {
    var id = UUID().uuidString
    var hospital: Location?
    var selected = false
    var hospitalID: String
}

class ODHospitals: ObservableObject {
    @Published var appointments = [OrganAppointment]()
    @Published var appointmentsWithin = [DAppointment]()
    @Published var odHospitals = [odHospital]()
    @Published var hospitalsID = [String]()
    
    @ObservedObject var lm = LocationManager()
    @State var listener: ListenerRegistration?
    
    let db = Firestore.firestore()
    
    func fetchData() {
        self.listener = db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.appointments = documents.map { (queryDocumentSnapshot) -> OrganAppointment in
                print("documents")
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
                let organ = data["organ"] as? String ?? ""
                print("\(organ)")
                let aptDuration = 60.0
                let docId = queryDocumentSnapshot.documentID
                if(organ == Constants.selected.selectedOrgan.organ){
                    print("hereee")
                    if(!self.hospitalsID.contains(hospital)){
                        self.hospitalsID.append(hospital)
                    }
                }
                
                var apt =
                OrganAppointment(type: type, startTime: startTime, endTime: endTime,
                                 aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ, mainDocID: docId)
                apt.appointments = appointments
                return apt
                
            }
        }
        
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
                let startTime = stamp1?.dateValue() ?? Date()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2?.dateValue() ?? Date()
                
                return DAppointment(type: type, startTime: startTime, endTime: endTime, donor: donor, hName: hName, confirmed: confirmed, booked: booked)
            }
        }
        
        return self.appointmentsWithin
    }
    
    
    func fetchHospitalsInfo(){
        var hospitals:[odHospital] = []
        
        db.collection("hospitalsInformation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(self.hospitalsID.contains(document.documentID)){
                        print("heree222")
                        let doc = document.data()
                        let latitude:Double = doc["latitude"] as! Double
                        let longitude:Double = doc["longitude"] as! Double
                        let name: String = doc["name"] as! String
                        let city: String = doc["city"] as! String
                        let area: String = doc["area"] as! String
                        hospitals.append(odHospital(hospital: Location(name: name, lat: latitude, long: longitude, city: city, area: area, distance: self.calculateDistance( lat: latitude, long: longitude)), selected: false, hospitalID: document.documentID))
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                self.odHospitals = hospitals.sorted(by: { (h0: odHospital, h1: odHospital) -> Bool in
                    return h0.hospital!.distance! < h1.hospital!.distance!
                })
            }
        }
        
        let hospitals2 = hospitals.sorted(by: { (h0: odHospital, h1: odHospital) -> Bool in
            return h0.hospital!.distance! < h1.hospital!.distance!
        })
        
        self.odHospitals = hospitals2
    }
    
    func calculateDistance(lat: Double, long: Double ) -> Double {
        let userLocation:CLLocationCoordinate2D = lm.getUserLocation()!
        let location:CLLocation = lm.location!
        
        let currentLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let DestinationLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: DestinationLocation) / 1000
        return distance
    }
}

struct AODHospitalList_Previews: PreviewProvider {
    static var previews: some View {
        AODHospitalList(config: Configuration())
    }
}


struct RadioButton2: View {
    //    @Binding
    var matched: Bool    //the variable that determines if its checked
    //    @Binding var checkedIndex: Int
    //    var currentIndex: Int
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    
    
    var body: some View {
        Group{
            if matched {
                ZStack{
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 15, height: 15)
                        .overlay(Circle().stroke(mainLight, lineWidth: 3))
                    Circle()
                        .fill(mainLight)
                        .frame(width: 6, height: 6)
                    
                    //                    Circle()
                    //                        .fill(mainLight)
                    //                        .frame(width: 18, height: 18)
                    //                    Circle()
                    //                        .fill(Color.white)
                    //                        .frame(width: 6, height: 6)
                }
                //                .onTapGesture {
                //                    self.checked = false
                //                }
            } else {
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                //                    .onTapGesture {
                //                        self.checked = true
                //
                //                    }
            }
        }
    }
}

struct UIKitView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Alive4thVC
    
    
    func makeUIViewController(context: Context) -> Alive4thVC {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "alive4thVC") as! Alive4thVC
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: Alive4thVC, context: Context) {
        
    }
}
