//
//  Alive1stVC.swift
//  Yumn
//
//  Created by Rawan Mohammed on 20/04/2022.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

class AliveFirstVC: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var innerPopup: UIView!
    @IBOutlet weak var blackBlurredView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
        
        // Notification
        // step 1: Ask for permission | Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]) { granted, error in
        }
        
        popupView.layer.cornerRadius = 30
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: ChooseOrganButton(config: configuration))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = container.bounds
        container.addSubview(controller.view)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
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
    
    func showPopup(){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)

        popupView.isHidden = false
        blackBlurredView.isHidden = false
        
        let configuration = Configuration()
        let controller = UIHostingController(rootView: CannotDonatePopup(config: configuration))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerPopup.bounds
        innerPopup.addSubview(controller.view)
    }
    
    func hidePopup(){
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)

        popupView.isHidden = true
        blackBlurredView.isHidden = true
        
        innerPopup.removeSubviews()
    }
    
    func moveToKindneySection(){
        performSegue(withIdentifier: "donateKidney", sender: nil)
    }
    
    func moveToLiverSection(){
        performSegue(withIdentifier: "donateLiver", sender: nil)
    }
}
