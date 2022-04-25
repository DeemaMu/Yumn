//
//  Location.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/02/2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    var id = UUID().uuidString
    let name:String
    let lat:Double
    let long:Double
    let city:String
    let area:String
    var distance:Double?
}
