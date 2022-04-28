//
//  appointmentsSeguesViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 27/09/1443 AH.
//

import UIKit

class appointmentsSeguesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showVOppPage" {
            
            // Create a new variable to store the instance of updateBloodShortageVC
            let destinationVC = segue.destination as! updateBloodShortageVC
            destinationVC.delegate=self
            destinationVC.bloodTypeArray = bloodRow
            destinationVC.oldBloodTypeArray = bloodRow
            
        }
        
        
        if segue.identifier == Constants.Segue.updateOrgansShSegue { // make sure it matches the segue id
            
            // Create a new variable to store the instance of updateBloodShortageVC
            let destinationVC = segue.destination as! updateOrganShortageVC
            destinationVC.delegate=self
            destinationVC.organsArray = organsRow
            destinationVC.oldOrgansArray = organsRow
            //updateOrganShortageVC
        }
        
    }
    
    

}
