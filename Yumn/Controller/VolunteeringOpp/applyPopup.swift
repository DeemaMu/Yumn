//
//  applyPopup.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//


import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class applyPopup: UIViewController{
    
    
    @IBOutlet weak var titleMSG: UILabel!
    @IBOutlet weak var desMSG: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    
    var applied = false
    var docID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(applied)
        setUp(applied)
    }
    
    func setUp(_ applied : Bool){
        backView.layer.cornerRadius = 40
        confirmButton.layer.cornerRadius = 20
        okayButton.layer.cornerRadius = 20
        
        if (applied ){
            titleMSG.text = "تم طلب التقديم مسبقاً"
            desMSG.text = "عذراً، تم التقديم على هذه الفرصة مسبقاً"
            confirmButton.isHidden = true
            cancelButton.isHidden = true
            okayButton.isHidden = false
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        // Apply Query
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid

        DispatchQueue.main.async {
            db.collection("volunteeringOpp").document(self.docID).collection("applicants").document(uid!).setData([
                        "uid": uid! ,
                        "status":"pending"]){ error in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            print ("Error in Apply")
                        }
                    }
              
            }
        // Go back
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        // dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okay(_ sender: Any) {
        // dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
}


