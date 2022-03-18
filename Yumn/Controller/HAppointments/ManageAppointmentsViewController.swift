//
//  ManageAppointmentsViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseAuth

class ManageAppointmentsViewController: UIViewController {
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var popupMsg: UILabel!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var popupStack: UIStackView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        
        
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            guard let mainFont = UIFont(name: "Tajawal", size: 18) else {
                fatalError("""
                    Failed to load the "CustomFont-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            let mssg = "حياك الله، تو ما نور يُمْن"
            
            self.showToastHome(message: mssg, font: mainFont, image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))}
        
        
        
        
        super.viewDidLoad()
        
        
        
        popupStack.superview?.bringSubviewToFront(popupStack)

           popupView.layer.cornerRadius = 35
           cancelBtn.layer.cornerRadius = 20
           confirmBtn.layer.cornerRadius = 20
        
        
        
        let childView = UIHostingController(rootView: CalenderAndAppointments())
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
    }
    
    @IBAction func onPressedLogout(_ sender: Any) {
        
        
        popupTitle.text = "تأكيد تسجيل الخروج"
        popupMsg.text = "هل أنت متأكد من أنك تريد تسجيل الخروج؟"

       popupView.isHidden = false
       blurredView.isHidden = false
        
    }
    
    @IBAction func onPressedCancel(_ sender: Any) {
      
        
       popupView.isHidden = true
       blurredView.isHidden = true

        
    }
    
    
    @IBAction func onPressedConfirm(_ sender: Any) {
        
        
        do
        {
            try Auth.auth().signOut()
            transitionToLogIn()
            
            
      
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            
           
        }
        
    }
    
    
    
    func transitionToLogIn(){
        Constants.Globals.isLoggingOut = true

       
        let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
       
        
    }
    
    
    
    func showToastHome(message : String, font: UIFont, image: UIImage){
        
        let toastLabel = UILabel(frame: CGRect(x: 5, y: 45, width: self.view.frame.size.width-10, height: 70))
        
        
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        
        
        let imageView = UIImageView(frame: CGRect(x: self.view.frame.size.width-70, y: 10, width: 45, height: 45))
        imageView.layer.masksToBounds = true
        
        imageView.image = image
        imageView.layer.cornerRadius = 10
        
        
        
        toastLabel.addSubview(imageView)
        
        self.navigationController?.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 6, delay: 5, options:
                        
                        
                            .transitionFlipFromTop, animations: {
            
            
            toastLabel.alpha = 0.0
            
        }, completion: {(isCompleted) in
            
            
            
            toastLabel.removeFromSuperview()
            
            
            
        })
    }
    
}

