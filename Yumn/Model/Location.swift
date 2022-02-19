//
//  Location.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/02/2022.
//

import Foundation
import CoreLocation

struct Location{
    let name:String
    let lat:Double
    let long:Double
    let city:String
    let area:String
    
    func calculateDistance(latitude: Double, longitude: Double ) -> Double {
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        let DestinationLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: DestinationLocation) / 1000
        return distance
        
    }
}
