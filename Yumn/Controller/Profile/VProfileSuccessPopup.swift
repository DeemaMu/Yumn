//
//  VProfileSuccessPopup.swift
//  Yumn
//
//  Created by Deema Almutairi on 07/05/2022.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class VProfileSuccessPopup: UIViewController{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var okayButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        backView.layer.cornerRadius = 40
        okayButton.layer.cornerRadius = 20
    }

    @IBAction func okayPressed(_ sender: Any) {
        // dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
