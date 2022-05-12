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
    
    var cancellable : AnyCancellable?
    
    var selectedOrgans: [String:Bool]?
    
    var donor: Donor?
    
    var organs: [String] = []
    
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
        thankYouPopup.layer.cornerRadius = 30
        
        
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
    
    
    
    
    @IBAction func cancel(_ sender: UIButton) {
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
    }
    
    // The method called from the swiftui button to display the confirmation message
    func showConfirmationMessage(selected: [String:Bool], donor: Donor){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        // Sets the selected organs dictionary
        selectedOrgans = selected
        // Sets the after death donor
        self.donor = donor
    }
    
    // The method called from the swiftui button to display the confirmation message
    @IBAction func confirm(_ sender: UIButton) {
        
        // Transfers the selected organs from the dictionary to the organs array
        for organ in selectedOrgans! {
            if(organ.value){
                self.organs.append(organ.key)
            }
        }
        
        // If the save was successful display seccuess message, otherwise display fail message
        cancellable = saveData().receive(on: DispatchQueue.main
        ).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] success in
            print(success)
            if(success){
                self!.showThankYou()
            } else {
                components().showToast(message: "فشل في حفظ العملية. الرجاء المحاولة لاحقًا",
                                       font: .systemFont(ofSize: 20),
                                       image: UIImage(named: "yumn-1")!, viewC: self!)
            }
        })
    }
    
    // Saving data to database
    func saveData() -> Future<Bool, Error>{
        
        return Future<Bool, Error> { [weak self] promise in
            DispatchQueue.main.async {
                let newDoc = self?.db.collection("afterDeathDonors").document(self!.userID)
                // Set new document data
                newDoc?.setData(["bloodType": self?.donor?.bloodType, "city": self?.donor?.city,
                                 "name": self?.donor?.name, "nationalID": self?.donor!.nationalID,
                                 "organs": self?.donor?.organs,
                                 "uid": self!.userID]) { error in
                    
                    if (error == nil){
                        promise(.success(true))
                    } else {
                        promise(.failure(error!))
                    }
                }
            }
        }
    }
    
    
    
    func showThankYou(){
        thankYouPopup.superview?.bringSubviewToFront(thankYouPopup)
        popupView.isHidden = true
        thankYouPopup.isHidden = false
        let configuration = Configuration()
        let controller = UIHostingController(rootView: ThankYouPopup(config: configuration, controllerType: 2))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerThanku.bounds
        innerThanku.addSubview(controller.view)
    }
    
    func thankYou(){
        performSegue(withIdentifier: "wrapToHome", sender: nil)
    }
    
}

import Combine
