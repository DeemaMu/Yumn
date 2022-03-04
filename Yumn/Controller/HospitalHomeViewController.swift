//
//  HospitalHomeViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 22/02/2022.
//
import FirebaseAuth
import UIKit

class HospitalHomeViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

                    let mssg = "حياك الله، تو ما نور يُمْن"
                    self.showToast(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))
        }
                
  

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func signOutOnPressed(_ sender: Any) {
        
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
    
    func transitionToLogIn(){
        
        // I have to check if the user is volunteer or hospital, in the log in
       let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
    }

    
    

}
