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
    
    
    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgDescription: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        backView.layer.cornerRadius = 40
        confirmButton.layer.cornerRadius = 20
        okayButton.layer.cornerRadius = 20
    }
    
    @IBAction func confirm(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        // 1. get the Doc reference
        let docRef = db.collection("hospitalsInformation").document(uid!)

        // 2. read the hospital name
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }

            guard let hospitalName = data["name"] as? String else {
                return
            }
            // 3. Save data to volunteeringOpp collection
            DispatchQueue.main.async {
                // save the post date
                let today = Date()
                
                db.collection("volunteeringOpp").document().setData([
                    "title":Constants.VolunteeringOpp.title,
                    "date": Constants.VolunteeringOpp.date,
                    "endDate": Constants.VolunteeringOpp.endDate,
                    "start_date":Constants.VolunteeringOpp.start_date,
                    "end_date":Constants.VolunteeringOpp.end_date,
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
        
        showSuccessMessage()
        
    }
    @IBAction func cancel(_ sender: Any) {
        // dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSuccessMessage(){
        msgTitle.text = "تمت الإضافة"
        msgDescription.text = "تمت  إضافة الفرصة التطوعية بنجاح!"
        confirmButton.isHidden = true
        cancelButton.isHidden = true
        okayButton.isHidden = false
    }
    
    @IBAction func okayPressed(_ sender: Any) {
        
        // Update collection view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotification"), object: nil)
        
        // Go back
        performSegue(withIdentifier: "popupSegue", sender: self)
        
    }
    
    
}

