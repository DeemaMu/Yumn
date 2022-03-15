//
//  ViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 24/01/2022.
//

import UIKit
import SwiftUI
import CoreLocation
import FirebaseAuth

class VHomeViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var blurredView: UIView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    
    @ObservedObject var lm = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: lm.location))")
        
        popupView.layer.cornerRadius = 35
        cancelButton.layer.cornerRadius = 20
        confirmBtn.layer.cornerRadius = 20

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBloodDonation" {
            let destinationVC = segue.destination as! BloodDonationViewController
            destinationVC.userLocation = lm.getUserLocation()
            destinationVC.location = lm.location
//            destinationVC.advice = calculatorBrain.getAdvice()
//            destinationVC.color = calculatorBrain.getColor()
        }
    }
    

    @IBAction func onPressedConfirmBtn(_ sender: Any) {
    
    
        do
            {
        try Auth.auth().signOut()
                transitionToLogIn()
                
                
                // add a flushbar
               
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                
                // Show pop up message
            }

        
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
    
    func transitionToLogIn(){
        
        // I have to check if the user is volunteer or hospital, in the log in
       let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
       // SignInViewController.showToast(message: "تم تسجي لالخروج بنجاح", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))}

    }

        

    }
    


