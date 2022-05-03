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
                    
                    
                    self.showToast2(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn") ?? UIImage(named: "")! ))}

                
                print (Constants.Globals.firstNameFromdb)
            } else {
                print("Document does not exist")
            }
        }

        
        
        
        
       
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
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


extension UIViewController {

    func showToast2(message : String, font: UIFont, image: UIImage){

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

