//
//  HomeViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 07/02/2022.
//
import FirebaseAuth
import UIKit
import FirebaseAuth
import Firebase


class HomeViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("volunteer").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    // Put your code which should be executed with a delay here
                let name = document.get("firstName") as! String
                    let mssg = "حياك الله " + name  + "، تو ما نور يُمْن"
                    self.showToast(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))}

                
                print (Constants.Globals.firstNameFromdb)
            } else {
                print("Document does not exist")
            }
        }

        
        
        
        
       
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
    @IBAction func onPressedLogOut(_ sender: Any) {
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
        
       // SignInViewController.showToast(message: "تم تسجي لالخروج بنجاح", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))}

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
    class NewOneViewController: UIViewController {

    
        @IBOutlet weak var scroll: UIScrollView!
        
      
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
           
            
            
            
            
            // Do any additional setup after loading the view.
        }


}

}
