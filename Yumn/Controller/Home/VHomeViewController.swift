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
import ContextMenuSwift

class VHomeViewController: UIViewController {
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var whiteView: RoundedView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupStack: UIStackView!
    
    @IBOutlet weak var blurredView: UIView!
    
//    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var menuView: UIView!
    
    
    @ObservedObject var lm = LocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 23) else {
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        let nav = self.navigationController?.navigationBar
//        guard let customFont = UIFont(name: "Tajawal-Bold", size: 23) else {
//            fatalError("""
//                Failed to load the "Tajawal" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
//        nav?.tintColor = UIColor.white
//        nav?.barTintColor = UIColor.white
//        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
//    }

    override func viewDidLoad() {
        
     
      //  whiteView.layer.zPosition = -8
        //blurredView.layer.zPosition = 1
       // popupView.layer.zPosition = 9


        
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
                        
                        self.showToast2(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))
                        
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
        
        popupView.layer.cornerRadius = 35
        cancelButton.layer.cornerRadius = 20
        confirmBtn.layer.cornerRadius = 20
        
      
        popupStack.superview?.bringSubviewToFront(popupStack)
        

        
        
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
                
                Constants.UserInfo.userID = ""
                
                transitionToLogIn()
                
                
                // add a flushbar
               
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                
                // Show pop up message
            }

        
    }
    
    
//    @IBAction func onPressedLogout(_ sender: Any) {
//
//
//        popupTitle.text = "تأكيد تسجيل الخروج"
//        popupMsg.text = "هل أنت متأكد من أنك تريد تسجيل الخروج؟"
//
//        popupView.isHidden = false
//        blurredView.isHidden = false
//
//    }
    
    
    
    @IBAction func onPressedCancel(_ sender: Any) {
   
        
        popupView.isHidden = true
        blurredView.isHidden = true
        
        
        
    }
    
    func transitionToLogIn(){
        
        Constants.Globals.isLoggingOut = true
        // I have to check if the user is volunteer or hospital, in the log in
       let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
       // SignInViewController.showToast(message: "تم تسجي لالخروج بنجاح", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))}

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

        UIView.animate(withDuration: 10, delay: 5, options:
                        
                        
                        .transitionFlipFromTop, animations: {

                            
             toastLabel.alpha = 0.0

        }, completion: {(isCompleted) in
            
            

            toastLabel.removeFromSuperview()



        })
    }
      
    @IBAction func viewMenu(_ sender: Any) {
        let profile = ContextMenuItemWithImage(title: "الصفحة الشخصية", image: UIImage.init(named: "pofileHospital")!)
        let logout = ContextMenuItemWithImage(title: "تسجيل الخروج", image: UIImage.init(named: "signout")!)
        
        CM.items = [profile,logout]
        CM.showMenu(viewTargeted: menuView, delegate: self, animated: true)
    }
    }
    
    

