//
//  HospitalsController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 23/02/2022.
//

import Foundation
import CoreLocation
import Firebase

struct HospitalsController {
    var userLocation:CLLocationCoordinate2D?
    
//    var sortedHospitals:[Location] = [
//        Location(name: "دلة", lat: 25.8777, long: 42.4444, city: "الرياض", area: "النخيل"),
//        Location(name: "الملك خالد", lat: 25.8778, long: 45.4444, city: "الرياض", area: "الدرعية"),
//        Location(name: "المملكة", lat: 26.8778, long: 46.4444, city: "الرياض", area: "الربيع")
//    ]
    
    let db = Firestore.firestore()
    var sortedHospitals:[Location] = []
    
    mutating func getHospitals() -> [Location] {
        
        sortedHospitals = RetrieveHospitals().sorted(by: { (h0: Location, h1: Location) -> Bool in
            return h0.distance! < h1.distance!
        })
        
        return sortedHospitals
    }
    

    func RetrieveHospitals() -> [Location] {
        
        var hospitals:[Location] = []
        
        db.collection("hospitalsInformation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    let latitude:Double = doc["latitude"] as! Double
                    let longitude:Double = doc["longitude"] as! Double
                    let name: String = doc["name"] as! String
                    let city: String = doc["city"] as! String
                    let area: String = doc["area"] as! String
                    hospitals.append(Location(name: name, lat: latitude, long: longitude, city: city, area: area, distance: calculateDistance( lat: latitude, long: longitude)))
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        return hospitals
    }
    
//    mutating func sortHospitals()  -> [Location] {
//        var i=0
//        for h in sortedHospitals {
//            sortedHospitals[i].distance = calculateDistance( lat: h.lat, long: h.long)
//            i+=1
//        }
//
//        let hospitals = sortedHospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
//            return h0.distance! < h1.distance!
//        })
//        return hospitals
//    }
    
    func calculateDistance(lat: Double, long: Double ) -> Double {
        let currentLocation = CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        let DestinationLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: DestinationLocation) / 1000
        return distance
    }
    
    
}

extension BloodDonationViewController {
    
    func getHospitals() -> [Location] {

        var hospitals:[Location] = []

        db.collection("hospitalsInformation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    let latitude:Double = doc["latitude"] as! Double
                    let longitude:Double = doc["longitude"] as! Double
                    let name: String = doc["name"] as! String
                    let city: String = doc["city"] as! String
                    let area: String = doc["area"] as! String
                    hospitals.append(Location(name: name, lat: latitude, long: longitude, city: city, area: area, distance: self.calculateDistance( lat: latitude, long: longitude)))
                    print("\(document.documentID) => \(document.data())")
                }
                self.sortedHospitals = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
                    return h0.distance! < h1.distance!
                })
                DispatchQueue.main.async {
                    self.tableMain.reloadData()
                }

            }
        }
        let hospitals2 = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
            return h0.distance! < h1.distance!
        })
        return hospitals2
    }

    func calculateDistance(lat: Double, long: Double ) -> Double {
        let currentLocation = CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        let DestinationLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: DestinationLocation) / 1000
        return distance
    }
    
}
