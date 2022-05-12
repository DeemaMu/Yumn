//
//  Alive4thVC.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import UserNotifications

class BloodAppointmentsVC: UIViewController {
        
    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var blackBlurredView: UIView!

    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var innerPopUp: UIView!
    
    @IBOutlet weak var appointmentsSection: UIView!
            
    @IBOutlet weak var thankYouPopup: UIView!
    @IBOutlet weak var innerThanks: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //step 1: Ask for permission | Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]) { granted, error in
        }
        
        viewWillAppear(true)

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        popupView.layer.cornerRadius = 30
        thankYouPopup.layer.cornerRadius = 30
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: SelectBDAppointment(config: configuration, selectedDate: Date()))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = appointmentsSection.bounds
        appointmentsSection.addSubview(controller.view)
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        
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
    
    func confirmAppoitment(apt: BloodAppointment, exact: DAppointment){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: ConfirmBloodAppointmentPopUp(config: configuration, appointment: apt, exact: exact))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerPopUp.bounds
        innerPopUp.addSubview(controller.view)
        

    }
    
    func cancel(){
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        
        innerPopUp.removeSubviews()
    }
    
    func confirm(){
        thankYouPopup.superview?.bringSubviewToFront(thankYouPopup)
        popupView.isHidden = true
        thankYouPopup.isHidden = false
        let configuration = Configuration()
        let controller = UIHostingController(rootView: ThankYouPopup(config: configuration, controllerType: 3))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerThanks.bounds
        innerThanks.addSubview(controller.view)
    }
    
    func fail(){
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        components().showToast(message: "حدث خطأ في اضافة الموعد. الرجاء المحاولة لاحقًا.", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn")!, viewC: self)
        innerPopUp.removeSubviews()
    }
    

    
    func thankYou(){
        performSegue(withIdentifier: "wrapToHome", sender: nil)
    }
    
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
