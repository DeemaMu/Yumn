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

class VViewAppointmentsVC: UIViewController {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var innerPopup: UIView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
//    @IBOutlet weak var popupTitle: UILabel!
//
//    @IBOutlet weak var popupMsg: UILabel!
//
//    @IBOutlet weak var okBtn: UIButton!
//
//    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var selectionHolder: UIView!
    
    @State var organAppointmentsList = [retrievedAppointment]()
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
            
        popupView.superview?.bringSubviewToFront(popupView)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //        contBtn.layer.cornerRadius = 25
//        okBtn.layer.cornerRadius = 15
//        saveBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let configuration = Configuration()
        let controller = UIHostingController(rootView: VAppointmentsView(config: configuration))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        self.addChild(controller)
        controller.view.frame = self.selectionHolder.bounds
        self.selectionHolder.addSubview(controller.view)
        
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
        
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
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
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
    }
    
    func showConfirmationMessage(selected: [String:Bool], donor: Donor){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
    }
    
//
    func cancel(apt: retrievedAppointment) {
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        let configuration = Configuration()
        let controller = UIHostingController(rootView: deleteAppointment(config: configuration,appointment: apt, controllerType: 1))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerPopup.bounds
        innerPopup.addSubview(controller.view)
    }
    
//
//    func getDataFromDatabase( completion: @escaping([retrievedAppointment]) -> Void) {
//        let retrievedData: [retrievedAppointment] = getUserOA()
//        // 'Get data from database' code goes here
//        // In this example, the data received will be of type 'String?'
//        // Once you've got your data from the database, which in this case is a string
//        // Call your completion block as follows
//        completion(retrievedData)
//    }
//
    func moveToOldApts(){
        performSegue(withIdentifier: "goToOldApts", sender: nil)
    }
    
    func moveToFutureApts(){
        performSegue(withIdentifier: "goToFuture", sender: nil)
    }
    
    
    //    @IBAction func confirm(_ sender: UIButton) {
    //        thankYouPopup.superview?.bringSubviewToFront(thankYouPopup)
    //        popupView.isHidden = true
    //        thankYouPopup.isHidden = false
    //
    //        for organ in selectedOrgans! {
    //            if(organ.value){
    //                self.organs.append(organ.key)
    //            }
    //        }
    //
    //        if(saveDate()){
    //            let configuration = Configuration()
    //            let controller = UIHostingController(rootView: ThankYouPopup(config: configuration, controllerType: 2))
    //            // injects here, because `configuration` is a reference !!
    //            configuration.hostingController = controller
    //            addChild(controller)
    //            controller.view.frame = innerThanku.bounds
    //            innerThanku.addSubview(controller.view)
    //        }
    //    }
    //
    //    func saveDate() -> Bool {
    //        var added = true
    //        let newDoc = db.collection("afterDeathDonors").document(userID)
    //
    //        newDoc.setData(["bloodType": self.donor!.bloodType, "city": self.donor!.city, "name": self.donor!.name, "nationalID": self.donor!.nationalID, "organs": self.donor!.organs,
    //                        "uid": userID]) { error in
    //
    //            if (error == nil){
    //                print("added")
    //            } else {
    //                print(error!)
    //                added = false
    //            }
    //        }
    //        return added
    //    }
    //
    //
    //    func thankYou(){
    //        performSegue(withIdentifier: "wrapToHome", sender: nil)
    //    }
    
}


struct retrievedAppointment : Identifiable {
    var id = UUID().uuidString
    var duration: Int?
    var date: Date?
    var startTime: Date?
    
    var endTime: Date?
    var hName: String?
    var hospitalID: String?
    var hospitalLocation: String?
    
    var mainAppointmentID: String?
    var appointmentID: String?
    var type: String?
    
    var organ: String?
}
