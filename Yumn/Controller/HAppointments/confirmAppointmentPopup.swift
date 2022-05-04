//
//  confirmAppointmentPopup.swift
//  Yumn
//
//  Created by Deema Almutairi on 30/04/2022.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class confirmAppointmentPopup: UIViewController{
    
    @IBOutlet weak var backView: UIView!

    var complete = false

    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 40
        okayButton.layer.cornerRadius = 20
    }

    @IBAction func done(_ sender: Any) {
        // Update collection
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateOnStatus"), object: nil)

        // Go back
        self.dismiss(animated: true, completion: nil)
    }
    
}


