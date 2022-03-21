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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        backView.layer.cornerRadius = 40
        confirmButton.layer.cornerRadius = 20
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
    
}


