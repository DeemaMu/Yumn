//
//  SignInViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 07/02/2022.
//
import FirebaseAuth
import Firebase
import FirebaseFirestore
import UIKit

class SignInViewController: UIViewController {
    

    let isUserLoggedIn:Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")

    // @IBOutlet weak var pView: UIView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var popUpStack: UIStackView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var popUpView: UIView!
    
    
    @IBOutlet weak var popUpTitle: UILabel!
    
    @IBOutlet weak var popUpMessage: UILabel!
    
    @IBOutlet weak var popUpButton: UIButton!
    
    @IBOutlet weak var blurredView: UIView!
    
    @IBOutlet weak var loadingGif: UIImageView!
    
    
    @IBOutlet weak var tryButton: UITextField!
    
    
    @IBOutlet weak var eyeButton: UIButton!
    
    //  @IBOutlet weak var signInStack: UIStackView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var emailError: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        if (isUserLoggedIn){
            let docRef = db.collection("volunteer").document(Auth.auth().currentUser?.uid ?? "")

            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {

                    print("Vol")
                    DispatchQueue.main.async {
                        transitionToHome()
                    }


                } else {
                    print("Man")
                    DispatchQueue.main.async {
                        transitionToHospitalHome()
                    }
                }

            }
        }
    }
    override func viewDidLoad() {
        
        
        if (Constants.Globals.isLoggingOut == true) {
            
            let mssg = "تم تسجيل خروجك بنجاح"
            
            let seconds = 0.25
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                
                self.showToastHome(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))}
        
            
            Constants.Globals.isLoggingOut = false
            
        }
        
        
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setUpElements()
        
        // Hide keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    func setUpElements(){
        
        
        
        
        loadingGif.superview?.bringSubviewToFront(loadingGif)
        
        
        
        //The line below removes the top navigation bar however it alters the textfields when the pop up appears
        
        
        //  navigationController?.hidesBarsOnTap = true
        
        popUpStack.superview?.bringSubviewToFront(popUpStack)
        
        
        
        
        
        
        
        
        
        
        styleTextFields(textfield: emailTextField)
        styleTextFields(textfield: passwordTextField)
        
        
        
        
        loadingGif.loadGif(name: "yumnLoading")
        
        
        emailTextField.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let image = UIImage(named: "mail")
        imageView.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
        imageView.image = image
        emailTextField.rightView = imageView
        
        
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let image2 = UIImage(named:  "lock")
        imageView2.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
        imageView2.image = image2
        passwordTextField.rightView = imageView2
        
        
        
        
        //  signInStack.setCustomSpacing(20, after: emailError)
        
        // Email validator link
        emailTextField.addTarget(self, action: #selector(validateEmail(textfield:)), for: .editingChanged)
        
        // Password validator link
        passwordTextField.addTarget(self, action: #selector(validatePassword(textfield:)), for: .editingChanged)
        
        
        //styling the eye toggle button
        let icon = UIImage(systemName: "eye.slash")
        eyeButton.setImage(icon, for: .normal)
        eyeButton.tintColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00)
        
        popUpView.layer.cornerRadius = 35
        popUpButton.layer.cornerRadius = 20
        
        
        
        
        
        
        
        
        logInButton.layer.cornerRadius = 20
        logInButton.layer.backgroundColor = UIColor(red: 56/225, green: 97/225, blue: 93/225, alpha: 1).cgColor
        
    }
    
    
    
    
    
    
    
    @objc func turnTextFieldTextfieldToRed(textfield: UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width , height: 2)
        
        bottomLine.backgroundColor = UIColor.red.cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    
    // Styling the textfields
    @objc func styleTextFields(textfield: UITextField){
        
        
        // It only worked this way in this page
        
        
        
        let bottomLine = CALayer()
        
        
        if (textfield.text!.isEmpty){
            bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width + 95, height: 2)
        } //was width + 120
        else {
            bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width  , height: 2)
            
            
        }
        
        bottomLine.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
        
    }
    
    
    
    
    // Email validation
    @objc func validateEmail(textfield: UITextField){
        
        
        
        
        // Required
        if (textfield.text!.count == 0) {
            emailError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
            emailLabel.alpha = 0
            
        }
        // Email format
        else if (!isEmailValid(textfield.text!)){
            emailError.text = "البريد الالكتروني غير صالح"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
            emailLabel.alpha = 1
            
        }
        
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            emailError.text="  "
            styleTextFields(textfield: emailTextField)
            emailLabel.alpha = 1
            
        }
    }
    
    
    
    // Pawordss validation
    @objc func validatePassword(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.count == 0) {
            passwordError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: passwordTextField)
            passwordLabel.alpha = 0
            
        }
        
        
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            passwordError.text="  "
            styleTextFields(textfield: passwordTextField)
            passwordLabel.alpha = 1
            
            
        }
    }
    
    
    
    // Email format validation
    func isEmailValid(_ email : String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: email)
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func logInTapped(_ sender: Any) {
        
        
        if (emailTextField.text!.isEmpty){
            emailError.text = "إجباري"
            turnTextFieldTextfieldToRed(textfield: emailTextField)
        }
        
        if (passwordTextField.text!.isEmpty){
            passwordError.text = "إجباري"
            turnTextFieldTextfieldToRed(textfield: passwordTextField)
        }
        
        
        // Email and password are filled and validated
        
        else if (emailError.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && passwordError.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            
            
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let check = emailError.text!.trimmingCharacters(in: .whitespacesAndNewlines) + passwordError.text!.trimmingCharacters(in: .whitespaces)
            
            // Empty or not valid fields
            if (check != "")
            {
                
                // Do nothing
            }
            
            
            else {
                
                
                // Log in
                
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    
                    // Blur the background
                    self.blurredView.isHidden = false
                    // Show Loading indicator
                    self.loadingGif.isHidden = false
                    
                    
                    if (error != nil)
                    {
                        
                        // If an error occurs hide the blurred view
                        self.blurredView.isHidden = true
                        // If an error occurs hide the loading indicator
                        self.loadingGif.isHidden = true
                        print (error!.localizedDescription)
                        
                        
                        //Network error
                        
                        if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
                        {
                            
                            self.blackBlurredView.isHidden = false
                            self.popUpView.isHidden = false
                            self.popUpTitle.text = "خطأ في الشبكة"
                            self.popUpMessage.text = "الرجاء التحقق من الاتصال بالشبكة"
                            
                            
                        }
                        
                        
                        
                        
                        // Invalid credentials
                        else {
                            
                            self.blackBlurredView.isHidden = false
                            self.popUpView.isHidden = false
                            self.popUpTitle.text = "مدخلات غير صالحة"
                            self.popUpMessage.text = "البريد الالكتروني أو الرقم السري غير صحيح"
                        }
                        
                        
                    } // no error
                    
                    
                    else
                        
                        // There exists a user and signed in
                    {

                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        // Check which user
                        let db = Firestore.firestore()
                        
                        
                        // Check if the user is a volunteer by using the uid
                        
                        let docRef = db.collection("volunteer").document(Auth.auth().currentUser?.uid ?? "")
                        
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                
                                // If volunteer is found remove the blurred view
                                self.blurredView.isHidden = true
                                // If volunteer is found remove the loading indicator
                                self.loadingGif.isHidden = true
                                
                                
                                
                                print("Document exists in volunteer")
                                
                                // Transition to volunteer home
                                
                                self.transitionToHome()
                                
                            } else {
                                
                                // Else the user is hospital
                                
                                
                                /*
                                 db.collection("hospital").whereField("email", isEqualTo: email)
                                 .getDocuments() { (querySnapshot, err) in
                                 if let err = err {
                                 
                                 
                                 // Show a pop up msg
                                 
                                 print (err)
                                 
                                 } else {
                                 
                                 
                                 
                                 for document in querySnapshot!.documents {
                                 print("\(document.documentID) => \(document.data())")
                                 */
                                print("User is hospital")
                                
                                
                                
                                
                                // The User is Hospital remove the blurred view
                                self.blurredView.isHidden = true
                                // The User is Hospital remove the loading indicator
                                self.loadingGif.isHidden = true
                                
                                
                                
                                // Transition to hospital home page
                                self.transitionToHospitalHome()
                                
                                
                                // flushbar
                                
                            } // Else The user is hospital
                            
                            
                        } // check if the user is volunteer
                        
                        
                    } // There exists a user and signed in
                    
                } // Log in
                
                
                
            } // Fields are not empty and validated
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }  // Email and password are filled and validated
        
    } // On pressed log in
    
    
    
    
    
    
    
    
    
    
    
    func transitionToHome(){
        
        print ("transitioning to v homeuntee")
        // I have to check if the user is volunteer or hospital, in the log in
        let volunteerHomeViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.volunteerHomeViewController) as? customTabBarVC
        
        view.window?.rootViewController = volunteerHomeViewController
        view.window?.makeKeyAndVisible()
        
        
        
    }
    
    
    
    func transitionToHospitalHome(){
        
        // I have to check if the user is volunteer or hospital, in the log in
        let hospitalHomeViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.hospitalHomeViewController) as? customTabBarVC
        
        view.window?.rootViewController = hospitalHomeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    @IBAction func eyeTapped(_ sender: Any) {
        
        
        if (eyeButton.currentImage == UIImage(systemName: "eye.slash")){
            
            eyeButton.setImage(UIImage(systemName: "eye")
                               , for: .normal)
            passwordTextField.isSecureTextEntry = false}
        else {
            eyeButton.setImage(UIImage(systemName: "eye.slash")
                               , for: .normal)
            passwordTextField.isSecureTextEntry = true
            
            
        }
    }
    
    
    
    @IBAction func onPressedOK(_ sender: Any) {
        
        self.popUpView.isHidden = true
        self.blackBlurredView.isHidden = true
        
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
