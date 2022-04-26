//
//  Alive4thVC.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class Alive4thVC: UIViewController {
        
    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var blackBlurredView: UIView!

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupMsg: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var appointmentsSection: UIView!
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewWillAppear(true)

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        okBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: SelectODAppointment(config: configuration, selectedDate: Date()))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = appointmentsSection.bounds
        appointmentsSection.addSubview(controller.view)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        if(Constants.selected.selectedOrgan.organ == "kidney"){
            self.title = "التبرع بكلية"
        }
        if(Constants.selected.selectedOrgan.organ == "liver"){
            self.title = "التبرع بجزء من الكبد"
        }

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav!.setBackgroundImage(UIImage(), for:.default)
        nav!.shadowImage = UIImage()
        nav!.layoutIfNeeded()
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func confirmAppoitment(apt: OrganAppointment, exact: DAppointment){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
    }
    
}


