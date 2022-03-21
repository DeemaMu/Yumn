//
//  addPopup.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class addPopup: UIViewController{
    
    

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        // 1. get the Doc
        let docRef = db.collection("hospitalsInformation").document(uid!)

        // 2. to get live data
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let hospitalName = data["name"] as? String else {
                return
            }
            //            guard let phone = data["phone"] as? String else {
            //                return
            //            }

            DispatchQueue.main.async {

                let today = Date()
                
                // Volunteer collection
                db.collection("volunteeringOpp").document().setData([
                    "title":Constants.VolunteeringOpp.title,
                    "date": Constants.VolunteeringOpp.date,
                    "workingHours": Constants.VolunteeringOpp.workingHours,
                    "location": Constants.VolunteeringOpp.location,
                    "description": Constants.VolunteeringOpp.description,
                    "gender": Constants.VolunteeringOpp.gender,
                    "hospitalName": hospitalName,
                    "postDate": today,
                    "posted_by": uid!]){ error in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            print ("error in adding the data")
                        }
                    }
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

