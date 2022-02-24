//
//  HospitalsController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 20/02/2022.
//

import Foundation
import CoreLocation
import Firebase

struct HospitalsController {
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
