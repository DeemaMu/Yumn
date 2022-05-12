//
//  cancelPopup.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class cancelPopup: UIViewController{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var docID = ""
    
    @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var desLabel: UILabel!
       
       @IBOutlet weak var okayButton: UIButton!
       var notEditable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(notEditable)
    }
    
    func setUp(_ notEditable : Bool){
            backView.layer.cornerRadius = 40
            confirmButton.layer.cornerRadius = 20
            okayButton.layer.cornerRadius = 20
            
            if (notEditable == true){
                titleLabel.text = "لا يمكن التعديل"
                desLabel.text = "عذراً، يوجد متقدمين على هذه الفرصة لذلك لايمكن تعديل المعلومات"
                confirmButton.isHidden = true
                cancelButton.isHidden = true
                okayButton.isHidden = false
            }
    }
    
    @IBAction func confirm(_ sender: Any) {
        // cancel Query
        let db = Firestore.firestore()
        db.collection("volunteeringOpp").document(docID).delete()
        
        // Update collection
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotification"), object: nil)
        
        // Go back
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okay(_ sender: Any) {
            // dismiss view
            self.dismiss(animated: true, completion: nil)
        }
    
}


