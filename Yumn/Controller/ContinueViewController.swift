//
//  ContinueViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/02/2022.
//
import FirebaseAuth
import Firebase
import UIKit

class ContinueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let style = styles()
    
    
    @IBOutlet weak var loadingGif: UIImageView!
    
    
    @IBOutlet weak var blurredView: UIView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMessage: UILabel!
    
    @IBOutlet weak var popupButton: UIButton!
    
    
    
//    @IBOutlet weak var weightLabel: UILabel!
//    @IBOutlet weak var bloodTypeLabel: UILabel!
    //    @IBOutlet weak var cityLabel: UILabel!
      
//    @IBOutlet weak var popupStack: UIStackView!
    

    
    
    
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var bloodTypeTexfield: UITextField!
    
    @IBOutlet weak var stepper2: UIImageView!
    
    @IBOutlet weak var cityError: UILabel!
    @IBOutlet weak var bloodError: UILabel!
    @IBOutlet weak var weightError: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    

//    @IBOutlet weak var backButton: UIButton!
//
//    @IBOutlet weak var whiteView: UIView!
    
    let thePicker = UIPickerView()
    
    let thePicker2 = UIPickerView()
    
    
    
    let bloodList = ["","O+", "O-", "AB+", "AB-", "B-", "B+", "A+", "A-" , "لا أعلم"]
    
    let cityList = ["الرياض", "مكة المكرمة","المدينة المنورة","جدة","تبوك","نجران","الطائف","ينبع","الخبر","الدمام","حائل","الباحة","ضباء","الأحساء", "جازان"]
    
    let weightList = ["", "أقل من ٥٠ كج", "٥٠ كج أو أعلى"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        popupStack.superview?.bringSubviewToFront(popupStack)
        
        
        popupView.layer.cornerRadius = 35
        popupButton.layer.cornerRadius = 20
        
        thePicker.delegate = self
        
        loadingGif.loadGif(name: "yumnLoading")
        
        
        
        bloodTypeTexfield.inputView = thePicker
        cityTextfield.inputView = thePicker
        weightTextfield.inputView = thePicker
        
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        
        
        
        
        
        
        
        
//        backButton.setImage(UIImage(systemName: "arrow.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .bold))
//                            , for: .normal)
//        backButton.tintColor = UIColor.white
        
        
        
        
        bloodTypeTexfield.addTarget(self, action: #selector(validateBlood(textfield:)), for: .allEvents)
        
        weightTextfield.addTarget(self, action: #selector(validateWeight(textfield:)), for: .allEvents)
        
        

        
//        whiteView.layer.cornerRadius = 35
        
        
        
        stepper2.image = UIImage(named: "stepper 2:2")
        
        
        styleTextFieldsWithPicker(textfield: cityTextfield)
        styleTextFieldsWithPicker(textfield: bloodTypeTexfield)
        styleTextFieldsWithPicker(textfield: weightTextfield)
        
        
        
        
        // city validator link
        cityTextfield.addTarget(self, action: #selector(validateCity(textfield:)), for: .allEvents)
        
        
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.backgroundColor = UIColor(red: 56/225, green: 97/225, blue: 93/225, alpha: 1).cgColor
        
        
//        femaleButton.layer.cornerRadius = 20
//        femaleButton.layer.borderWidth = 1
//        femaleButton.layer.borderColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
//
//        maleButton.layer.cornerRadius = 20
//        maleButton.layer.borderWidth = 1
//        maleButton.layer.borderColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
        
       

    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        //Blood Type Texfield
        if bloodTypeTexfield.isFirstResponder{
            return bloodList.count}
        
        // City texfield
        else if (cityTextfield.isFirstResponder)
        {
            return cityList.count
        }
        
        // weight texfield
        else if (weightTextfield.isFirstResponder)
        {
            return weightList.count
        }
        
        return 0
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //Blood Type Texfield
        if bloodTypeTexfield.isFirstResponder{
            return bloodList[row]
        }
        
        // City texfield
        else if (cityTextfield.isFirstResponder)
        {
            return cityList[row]
        }
        
        // Weight texfield
        else if (weightTextfield.isFirstResponder)
        {
            return weightList[row]
        }
        return nil
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Blood Type Texfield
        if bloodTypeTexfield.isFirstResponder{
            self.bloodTypeTexfield.text! = self.bloodList[row]
            self.view.endEditing(true)
        }
        //City Textfield
        else if (cityTextfield.isFirstResponder){
            self.cityTextfield.text! =  self.cityList[row]
            self.view.endEditing(true)
            
        }
        
        //weight Textfield
        else if (weightTextfield.isFirstResponder){
            self.weightTextfield.text! =  self.weightList[row]
            self.view.endEditing(true)
        }
        
    }
       
    @objc func donePressed(){
       // first responser
        self.view.endEditing(true)
        
        
        
    }
 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.bloodTypeTexfield {
            self.thePicker.isHidden = false
            //if you don't want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
    }
    
    
//    @IBAction func onPressedBackButton(_ sender: Any) {
//
//        _ = navigationController?.popViewController(animated: true)
//    }
//
    
    
    
    
    
    
    // Styling the textfields
    @objc func style(textfield: UITextField){
        textfield.delegate = self
        style.normalStyle(TextField: textfield)
    }
    
    
    
    
    
    
    // Styling the textfields with pickers
    @objc func styleTextFieldsWithPicker(textfield: UITextField){
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 18, width: textfield.frame.width + 7, height: 2)
        
        
        bottomLine.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
        
        
        
        
        
    }
    
    
    @objc func turnTextFieldTextfieldToRed(textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    
    
    // City validation
    @objc func validateCity(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            cityError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: cityTextfield)
//            cityLabel.alpha = 0
        }
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            cityError.text="  "
            style(textfield: cityTextfield)
            let city = textfield.text!.prefix(8)
            Constants.Globals.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
//            cityLabel.alpha = 1
            
            
            
        }
    }
    
    
    
    // weight validation
    @objc func validateWeight(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            weightError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: weightTextfield)
//            weightLabel.alpha = 0
        }
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            weightError.isHidden = true
            style(textfield: weightTextfield)
            let weight = textfield.text!.prefix(14)
            Constants.Globals.weight = weight.trimmingCharacters(in: .whitespacesAndNewlines)
//            weightLabel.alpha = 1
            
            
            
        }
    }
    
    // blood type validation
    @objc func validateBlood(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            bloodError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: bloodTypeTexfield)
//            bloodTypeLabel.alpha = 0
        }
        // White space so that the layout is not affected; however, trim it in the validation
        else {
            bloodError.text="  "
            style(textfield: bloodTypeTexfield)
            let blood = textfield.text!.prefix(2)
            Constants.Globals.bloodType = blood.trimmingCharacters(in: .whitespacesAndNewlines)
//            bloodTypeLabel.alpha = 1
            
        }
        
        
        
    }
    
    
    
    
   
    
    
//    @IBAction func onPressedMaleButton(_ sender: Any) {
//
//
//        maleButton.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 0.7)
//        femaleButton.backgroundColor = UIColor.white
//
//        maleButton.isSelected = true
//        femaleButton.isSelected = false
//        gender = "m"
//        Constants.Globals.gender = "m"
//
//
//
//    }
//
//
//
//
//    @IBAction func onPressedFemaleButton(_ sender: Any) {
//
//
//        femaleButton.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 0.7)
//
//        maleButton.backgroundColor = UIColor.white
//
//        femaleButton.isSelected = true
//        maleButton.isSelected = false
//        gender = "f"
//        Constants.Globals.gender = "f"
//
//
//    }
    

    
    
    @IBAction func onPressedSignUp(_ sender: Any) {
        
        // let check = cityError.text!.trimmingCharacters(in: .whitespacesAndNewlines) + bloodError.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // City not validated
        if (cityTextfield.text!.prefix(8).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
        {
            
            cityError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: cityTextfield)
        }
        
        //Blood type not selected
        if (bloodTypeTexfield.text!.prefix(2).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
        {
            bloodError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: bloodTypeTexfield)
            
            
        }
        
        // Weight not selected
        if (weightTextfield.text!.prefix(14).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
            
        {
            
            weightError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: weightTextfield)
            
        }
        
        
        else if (cityError.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && bloodError.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            
            // Create the User
            
            
            Auth.auth().createUser(withEmail: Constants.Globals.email, password: Constants.Globals.password) { (result, err) in
                
                
                // Blur the background
                self.blurredView.isHidden = false
                // Show Loading indicator
                self.loadingGif.isHidden = false
                
                
                // Check for errors
                
                if err != nil {
                    
                    
                    
                    
                    // There was an error creating the user
                    
                    // If an error occurs hide the blurred view
                    self.blurredView.isHidden = true
                    // If an error occurs hide the loading indicator
                    self.loadingGif.isHidden = true
                    
                    
                    print (err!.localizedDescription)
                    
                    
                    // Print the exact message to customize the error mesage later
                    print(err?.localizedDescription as Any)
                    
                    
                    // Show pop up message to the user
                    
                    
                    
                    
                    //Network error
                    
                    if (err!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
                    {
                        
                        self.blackBlurredView.isHidden = false
                        self.popupView.isHidden = false
                        self.popupTitle.text = "خطأ في الشبكة"
                        self.popupMessage.text = "الرجاء التحقق من الاتصال بالشبكة"
                    }
                    
                    // Couldn't create the user
                    else {
                        
                        self.blackBlurredView.isHidden = false
                        self.popupView.isHidden = false
                        self.popupTitle.text = "حصل خطأ"
                        self.popupMessage.text = "حصل خطأ أثناء إنشاء الحساب الرجاء المحاولة لاحقا"
                    }
                    
                    
                    print ("error in creating the user")
                    
                }
                
                
                
                else {
                    
                    // User was creted successfully, store the information
                    
                    let db = Firestore.firestore()
                    
                    
                    
                    // User collection
                    
                    
                    db.collection("users").document(result!.user.uid).setData([
                        "name":Constants.Globals.firstName + "" + Constants.Globals.lastName,
                        "userType": "volunteer",
                        "email": Constants.Globals.email,
                        "uid": result!.user.uid]){ error in
                            
                            if error != nil {
                                
                                print(error?.localizedDescription as Any)
                                
                                // Show error message or pop up message
                                
                                
                                print ("error in saving the user data")
                                
                                
                            }
                        }
                    
                    
                    
                    // Volunteer collection
                    db.collection("volunteer").document(result!.user.uid).setData([
                        "firstName":Constants.Globals.firstName,
                        "lastName": Constants.Globals.firstName,
                        "nationalID": Constants.Globals.id,
                        "email": Constants.Globals.email,
                        "phone": Constants.Globals.phone,
                        "gender": Constants.Globals.gender,
                        "birthDate": Constants.Globals.birthdate,
                        "weight": Constants.Globals.weight,
                        "city": Constants.Globals.city,
                        "bloodType": Constants.Globals.bloodType,
                        "points": 0,
                        "uid": result!.user.uid]){ error in
                            
                            if error != nil {
                                
                                print(error?.localizedDescription as Any)
                                
                                // Show error message or pop up message
                                
                                
                                print ("error in saving the volunteer data")
                                
                                
                            }
                        }
                    
                    
                    // If volunteer is created remove the blurred view
                    self.blurredView.isHidden = true
                    // If volunteer is created remove the loading indicator
                    self.loadingGif.isHidden = true
                    
                    
                    
                    
                    // Transition to the home screen
                    
                    self.transitionToHome()
                    
                    
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func transitionToHome(){
        
        // I have to check if the user is volunteer or hospital, in the log in
        let volunteerHomeViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.volunteerHomeViewController) as? TabBarController
        
        view.window?.rootViewController = volunteerHomeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    
    @IBAction func onPressedOK(_ sender: Any) {
        popupView.isHidden = true
        blackBlurredView.isHidden = true
    }
    
    
    
    
}



extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .transitionFlipFromTop, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    
}




