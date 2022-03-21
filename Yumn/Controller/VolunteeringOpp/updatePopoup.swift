//
//  updatePopoup.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class updatePopoup: UIViewController{
    
    

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var docID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        backView.layer.cornerRadius = 40
        confirmButton.layer.cornerRadius = 20
    }
    
    @IBAction func confirm(_ sender: Any) {
        // Add Query
        
        // User was creted successfully, store the information

        let db = Firestore.firestore()

        let today = Date()


        // Volunteer collection
        db.collection("volunteeringOpp").document(self.docID).updateData([
            "title":Constants.VolunteeringOpp.title,
            "date": Constants.VolunteeringOpp.date,
            "workingHours": Constants.VolunteeringOpp.workingHours,
            "location": Constants.VolunteeringOpp.location,
            "description": Constants.VolunteeringOpp.description,
            "gender": Constants.VolunteeringOpp.gender,
            "postDate": today]){ error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    print ("error in adding the data")
                }
            }
        // Update collections
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotification"), object: nil)
        
        // Go back
        performSegue(withIdentifier: "popupSegue", sender: self)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        // dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
}


