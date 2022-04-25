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

struct AODHospitalList: View {
    
    @ObservedObject var hVM = ODHospitals()
    
    
    @State var checked = false
    @State var controller: Alive3rdVC = Alive3rdVC()
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    
    let items: [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
    ]
    
    @ObservedObject var appointmentsVM = OrgansVM()
    
    
    let organs: [String] = ["الكلى", "الكبد", "الرئتين", "البنكرياس", "القلب", "الامعاء", "العظام", "نخاع العظم", "الجلد", "القرنيات"]
    var selected = [
        "الكلى": false,
        "الكبد":false,
        "الرئتين":false,
        "البنكرياس":false,
        "القلب":false,
        "الامعاء":false,
        "العظام":false,
        "نخاع العظم":false,
        "الجلد":false,
        "القرنيات":false,
    ]
    
    var body: some View {
        VStack(spacing: 20){
            HStack(){
                HStack(){
                    Text("الكل").font(Font.custom("Tajawal", size: 15))
                        .foregroundColor(.gray).padding(.top,4)
                    RadioButton(checked: $checked)
                }.padding(.leading)
                
                Spacer()
                Text("حجز موعد للفحص المبدئي").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(mainDark)
            }.onChange(of: checked){ newValue in
                //                self.selectAll()
            }
            .padding(.trailing)
            .padding(.bottom,10)
            
            HStack(){
                
                ForEach(hVM.odHospitals) { index in
                    Text("\(index.name)")
                }
        
            }
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: items, alignment: .center) {
                    ForEach(organs.dropLast(organs.count % 3), id: \.self) { index in
                        //                                card(organ: index)
                    }
                }
                LazyHStack {
                    ForEach(organs.suffix(organs.count % 3), id: \.self) { index in
                        //                                card(organ: index)
                    }
                }
            }
            Button(action: {
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
        
    }
    
    
        @ViewBuilder
        func card(hospital: Location) -> some View{
            let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    //        let raduis = 3
    //        let ySpread = 0
    
            Button(action: {
                buttonPressed(organ: organ)
            }
            ) {
                Text(organ).font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(self.organsVM.selected[organ]! ? .white : mainDark)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
                    .fill(self.organsVM.selected[organ]! ? mainDark : .white)
            )
            .frame(width: 90, height: 90, alignment: .center)
            .shadow(color: shadowColor,
                    radius: self.organsVM.selected[organ]! ? 0 : 3, x: 0
                    , y:  self.organsVM.selected[organ]! ? 0 : 6)
        }
    
//        func buttonPressed(organ: String){
//            self.organsVM.selected[organ]?.toggle()
//        }
//
//        func selectAll(){
//            if(checked){
//                for organ in self.organsVM.selected {
//                    self.organsVM.selected[organ.key]? = true
//                    }
//            } else {
//                for organ in self.organsVM.selected {
//                    self.organsVM.selected[organ.key]? = false
//                    }
//            }
//
//        }
    
}

class ODHospitals: ObservableObject {
    @Published var appointments = [OrganAppointment]()
    @Published var appointmentsWithin = [DAppointment]()
    @Published var odHospitals = [Location]()
    @Published var hospitalsID = [String]()
    
    @ObservedObject var lm = LocationManager()
    
    let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("appointments").whereField("type", in: ["organ"]).addSnapshotListener { (querySnapshot, error) in
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
                
                if(organ == Constants.selected.selectedOrgan.organ){
                    print("hereee")
                    if(!self.hospitalsID.contains(hospital)){
                        self.hospitalsID.append(hospital)
                    }
                }
            
                
                return OrganAppointment(appointments: appointments, type: type, startTime: startTime, endTime: endTime,
                                        aptDate: aptDate!, hospital: hospital, aptDuration: aptDuration, organ: organ)
                
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
    
    
    func fetchHospitalsInfo(){
        var hospitals:[Location] = []
        
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
                        hospitals.append(Location(name: name, lat: latitude, long: longitude, city: city, area: area, distance: self.calculateDistance( lat: latitude, long: longitude)))
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                self.odHospitals = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
                    return h0.distance! < h1.distance!
                })
            }
        }
        
        let hospitals2 = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
            return h0.distance! < h1.distance!
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
        AODHospitalList()
    }
}
