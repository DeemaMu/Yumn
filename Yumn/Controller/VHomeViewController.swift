//
//  ViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 24/01/2022.
//

import UIKit

class VHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBloodDonation" {
            let destinationVC = segue.destination as! BloodDonationViewController
//            destinationVC.bmiValue = calculatorBrain.getBMIValue()
//            destinationVC.advice = calculatorBrain.getAdvice()
//            destinationVC.color = calculatorBrain.getColor()
        }
    }
    


}

