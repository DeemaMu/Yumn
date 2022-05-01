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

class Alive4thVC: UIViewController {
        
    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var blackBlurredView: UIView!

    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var innerPopUp: UIView!
    
    @IBOutlet weak var appointmentsSection: UIView!
            
    @IBOutlet weak var thankYouPopup: UIView!
    @IBOutlet weak var innerThanks: UIView!
    
      
    var cancellables: Set<AnyCancellable> = []
      
    struct SubscriptionID: Hashable {}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewWillAppear(true)

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        popupView.layer.cornerRadius = 30
        thankYouPopup.layer.cornerRadius = 30
        
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
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        
//
//        FirestoreSubscription.subscribe(id: SubscriptionID(), docPath: "labels/title")
//              .compactMap(FirestoreDecoder.decode(LabelDoc.self))
//              .receive(on: DispatchQueue.main)
//              .map(\LabelDoc.value)
//              .store(in: &cancellables)
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: ConfirmAppointmentPopUp(config: configuration, appointment: apt, exact: exact))
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
        let controller = UIHostingController(rootView: ThankYouPopup(config: configuration, controllerType: 1))
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


import Combine
import FirebaseFirestore

struct FirestoreSubscription {
  static func subscribe(id: AnyHashable, docPath: String) -> AnyPublisher<DocumentSnapshot, Never> {
    let subject = PassthroughSubject<DocumentSnapshot, Never>()
    
    let docRef = Firestore.firestore().document(docPath)
    let listener = docRef.addSnapshotListener { snapshot, _ in
      if let snapshot = snapshot {
        subject.send(snapshot)
      }
    }
    
    listeners[id] = Listener(document: docRef, listener: listener, subject: subject)
    
    return subject.eraseToAnyPublisher()
  }
  
  static func cancel(id: AnyHashable) {
    listeners[id]?.listener.remove()
    listeners[id]?.subject.send(completion: .finished)
    listeners[id] = nil
  }
}

private var listeners: [AnyHashable: Listener] = [:]
private struct Listener {
  let document: DocumentReference
  let listener: ListenerRegistration
  let subject: PassthroughSubject<DocumentSnapshot, Never>
}

//
import Firebase

struct FirestoreDecoder {
    static func decode<T>(_ type: [String : Any]?) -> (DocumentSnapshot) -> T where T: Decodable {
        { snapshot in
            try! snapshot.data() as [String : Any]? as! T
        }
    }
}
