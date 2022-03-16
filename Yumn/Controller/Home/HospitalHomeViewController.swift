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
        
        
        
        super.viewDidLoad()
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

                    let mssg = "حياك الله، تو ما نور يُمْن"
            
                    self.showToast(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))}
        

        
                
        self.navigationController?.hideHairline()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 30) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 30) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark")!, NSAttributedString.Key.font: customFont]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
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

extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
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
        
    }
    
    




