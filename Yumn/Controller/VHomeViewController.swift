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
import Firebase

class VHomeViewController: UIViewController {
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMessage: UILabel!
    
    @IBOutlet weak var funcBtn: UIButton!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    @IBOutlet weak var topNavBar: UINavigationItem!
    
    @IBOutlet weak var popupview: UIView!
    @ObservedObject var lm = LocationManager()

    override func viewDidLoad() {
        
        popupview.layer.cornerRadius = 35
        okButton.layer.cornerRadius = 20
        funcBtn.layer.cornerRadius = 20


 
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("volunteer").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    
                    // Put your code which should be executed with a delay here
                    
                    
                let name = document.get("firstName") as! String
                    let mssg = "حياك الله " + name  + "، تو ما نور يُمْن"
                    
                    if (Constants.Globals.isLoggingIn == true){
                        
                        self.showToast(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))
                        
                        //To avoid showing the toast allover again while navigating
                        Constants.Globals.isLoggingIn = false
                        
                        
                    }
                else{
                    
                    //Don't show toast
                }
                }
                
                print (Constants.Globals.firstNameFromdb)
            } else {
                print("Document does not exist")
            }
        }
        
        
        super.viewDidLoad()
        print("\(String(describing: lm.location))")
        
        
        
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
    
    @IBAction func onPressedLogout(_ sender: Any) {
        
        //Show pop up wity 2 buttons
        
        blackBlurredView.isHidden = false
        popupview.isHidden = false
        popupTitle.text = "تأكيد تسجيل الخروج"
        popupMessage.text = "هل أنت متأكد أنك تريد تسجيل الخروج؟"
        
    }
    
    
    @IBAction func onPressedOk(_ sender: Any) {
        
        blackBlurredView.isHidden = true
        popupview.isHidden = true
        
        
    }
    
    @IBAction func funcPressed(_ sender: Any) {
        
   
            
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
    
    /*
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
      
        
        
         if (popupTitle.text == "تأكيد تسجيل الخروج"){
            return true
        }
        
        return false
        
     
        
    }
    */
    
    
    
    func transitionToLogIn(){
        
  
       let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
       // self.showToast(message: "mssg", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")!)
                                                                               
      //  let storyboard: UIStoryboard =  UIStoryboard.init(name: "SignIn",bundle: nil)
      //  let firstViewController: SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController;
        
       // firstViewController.showSnack();
        
        
    
        
                                                                               
  
    

        }
    
}



extension UIViewController {

    func showToast(message : String, font: UIFont, image: UIImage){

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

    UIView.animate(withDuration: 10, delay: 5, options:
                    
                    
                    .transitionFlipFromTop, animations: {

                        
         toastLabel.alpha = 0.0

    }, completion: {(isCompleted) in
        
        

        toastLabel.removeFromSuperview()



    })
}
    
}
