//
//  ViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 24/01/2022.
//

import UIKit
import SwiftUI
import CoreLocation

class VHomeViewController: UIViewController {
    
    @ObservedObject var lm = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: lm.location))")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBloodDonation" {
            let destinationVC = segue.destination as! BloodDonationViewController
            destinationVC.userLocation = lm.getUserLocation()
            destinationVC.location = lm.location
//            destinationVC.advice = calculatorBrain.getAdvice()
//            destinationVC.color = calculatorBrain.getColor()
        }
    }
    


}

