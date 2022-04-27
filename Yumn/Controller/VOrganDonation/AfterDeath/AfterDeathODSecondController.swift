//
//  AfterDeathODFirstController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI
import Firebase
import FirebaseAuth

class AfterDeathODSecondController: UIViewController {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var innerThanku: UIView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var selectionHolder: UIView!
    
    @IBOutlet weak var thankYouPopup: UIView!
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()

    
    var selectedOrgans: [String:Bool]?
    
    var questions = [false, false,false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
        
        popupView.superview?.bringSubviewToFront(popupView)
        
        popupTitle.text = "تأكيد التبرع"
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //        contBtn.layer.cornerRadius = 25
        okBtn.layer.cornerRadius = 15
        saveBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: AfterDeathOrganSelection(config: configuration))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = selectionHolder.bounds
        selectionHolder.addSubview(controller.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
    }
    
    func showConfirmationMessage(selected: [String:Bool]){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        selectedOrgans = selected
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        thankYouPopup.superview?.bringSubviewToFront(thankYouPopup)
        popupView.isHidden = true
        thankYouPopup.isHidden = false
        if(saveDate()){
            let configuration = Configuration()
            let controller = UIHostingController(rootView: ThankYouPopup(config: configuration, controllerType: 2))
            // injects here, because `configuration` is a reference !!
            configuration.hostingController = controller
            addChild(controller)
            controller.view.frame = innerThanku.bounds
            innerThanku.addSubview(controller.view)
        }
    }
    
    func saveDate() -> Bool {
        
        let newDoc = db.collection("afterDeathDonors").document()
        
//        newDoc.setData(["type": apt.type,"hospital": apt.hospital, "start_time": apt.startTime,
//                        "end_time": apt.endTime, "date": apt.aptDate, "appointment_duration": 30
//                        , "donors": apt.donors ]) { error in
//
//            if (error == nil){
//
//            } else {
//                print(error!)
//                self.added = false
//            }
//        }
        return true
    }
    
    func getUser() -> Donor {
        var donor = Donor()
        
        
        return donor
    }
    
    
    func thankYou(){
        performSegue(withIdentifier: "wrapToHome", sender: nil)
    }
    
}
