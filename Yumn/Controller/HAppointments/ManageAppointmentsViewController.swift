//
//  ManageAppointmentsViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import Foundation
import UIKit
import SwiftUI

class ManageAppointmentsViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: CalenderAndAppointments())
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
    }
}
