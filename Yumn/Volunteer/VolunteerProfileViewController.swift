//
//  VolunteerProfileViewController.swift
//
//  Created by Deema Almutairi on 15/02/2022.
//

import Foundation
import FirebaseFirestore
import UIKit

class VolunteerProfileViewController: UIViewController, UITextFieldDelegate {
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    
    @IBOutlet weak var nationalIDTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var bloodTypeTextField: UITextField!
    
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    // Error Messages
    
    @IBOutlet weak var firstNameMSG: UILabel!
    @IBOutlet weak var lastNameMSG: UILabel!
    @IBOutlet weak var nationalIDMSG: UILabel!
    @IBOutlet weak var emailMSG: UILabel!
    @IBOutlet weak var phoneMSG: UILabel!
    
    
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backView.layer.cornerRadius = 45
        saveButton.layer.cornerRadius = 45
        textFieldSetUP()
        createDatePicker()
        
        // Read Data
        profileInfo()
        
        // Hide
        saveButton(enabeld: false)
        hideErrorMSGs()
       
    }
    func saveButton(enabeld : Bool){
        saveButton.isEnabled = enabeld
    }
    func hideErrorMSGs(){
        firstNameMSG.isHidden = true
        lastNameMSG.isHidden = true
        nationalIDMSG.isHidden = true
        emailMSG.isHidden = true
        phoneMSG.isHidden = true
    }
    func profileInfo(){
        // 1. get the Doc
        let docRef = database.document("users/XtXzhe5lMWR2J04EAe5n4GMs2ar1")
        
        // 2. to get live data
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            guard let firstName = data["firstName"] as? String else {
                return
            }
            guard let lastName = data["lastName"] as? String else {
                return
            }
            guard let nationalID = data["nationalID"] as? Int else {
                return
            }
            guard let email = data["email"] as? String else {
                return
            }
            guard let phone = data["phone"] as? Int else {
                return
            }
            guard let gender = data["gender"] as? String else {
                return
            }
            guard let bloodType = data["bloodType"] as? String else {
                return
            }
            guard let birthdate = data["birthdate"] as? String else {
                return
            }
            guard let weight = data["weight"] as? Double else {
                return
            }
            guard let city = data["city"] as? String else {
                return
            }
            DispatchQueue.main.async {
                // Assign the values here
                self?.nameTextField.text = firstName
                self?.familyTextField.text = lastName
                self?.nationalIDTextField.text = String(nationalID)
                self?.emailTextField.text = email
                self?.phoneTextField.text = String(phone)
                self?.bloodTypeTextField.text = bloodType
                self?.birthdateTextField.text = birthdate
                self?.genderTextField.text = gender
                self?.weightTextField.text = String(weight)
                self?.cityTextField.text = city
            }
        }
    }
    
    func textFieldSetUP(){
        textFieldStyle(TextField: nameTextField)
        textFieldStyle(TextField: familyTextField)
        textFieldStyle(TextField: nationalIDTextField)
        textFieldStyle(TextField: emailTextField)
        textFieldStyle(TextField: phoneTextField)
        textFieldStyle(TextField: genderTextField)
        textFieldStyle(TextField: bloodTypeTextField)
        textFieldStyle(TextField: birthdateTextField)
        textFieldStyle(TextField: weightTextField)
        textFieldStyle(TextField: cityTextField)
    }
    
    func textFieldStyle(TextField : UITextField){
        TextField.delegate = self
        TextFieldStyle(TextField: TextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 56/255, green: 97/255, blue: 93/255, alpha: 1).cgColor
        
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
    }
    
    func TextFieldStyle(TextField : UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 2, width: TextField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        
        TextField.borderStyle = .none
        
        TextField.layer.addSublayer(bottomLine)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        TextFieldStyle(TextField: textField)
    }
    
    // Datepicker

func createDatePicker(){
    // toolbar
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    
    // Done button
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    toolBar.setItems([doneBtn], animated: true)
    // assign tool bar
    birthdateTextField.inputAccessoryView = toolBar
    
    //
    birthdateTextField.inputView = datePicker
    
    datePicker.datePickerMode = .date
}

@objc func donePressed(){
    // Formatter
    
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    
    birthdateTextField.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
}
    
    @IBAction func Update(_ sender: Any) {
        // get the Doc
        let docRef = database.document("users/XtXzhe5lMWR2J04EAe5n4GMs2ar1")
        
        // save data
        docRef.setData(["firstName": nameTextField.text!,
                        "lastName": familyTextField.text!,
                        "nationalID": Int(nationalIDTextField.text!)!,
                        "email": emailTextField.text!,
                        "phone": Int(phoneTextField.text!)!,
                        "gender": genderTextField.text!,
                        "bloodType": bloodTypeTextField.text!,
                        "birthdate": birthdateTextField.text!,
                        "weight": Double(weightTextField.text!)!,
                        "city": cityTextField.text!,
                        "uid" : "XtXzhe5lMWR2J04EAe5n4GMs2ar1",
                        "userType" : "Volunteer"])
    }
    
    @IBAction func firstNameChanged(_ sender: Any) {
        if let firstName = nameTextField.text
                {
                    if let errorMessage = invalidName(firstName)
                    {
                        firstNameMSG.text = errorMessage
                        firstNameMSG.isHidden = false
                    }
                    else
                    {
                        firstNameMSG.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    func invalidName(_ value: String) -> String?
        {
            let set = CharacterSet(charactersIn: value)
            if CharacterSet.decimalDigits.isSuperset(of: set)
            {
                return "يجب ان يحتوي على احرف فقط"
            }
            
            if value.count < 2
            {
                return "الرجاء ادخال اسم صحيح"
            }
            return nil
        }
    
    @IBAction func lastNameChanged(_ sender: Any) {
        if let lastName = familyTextField.text
                {
                    if let errorMessage = invalidName(lastName)
                    {
                        lastNameMSG.text = errorMessage
                        lastNameMSG.isHidden = false
                    }
                    else
                    {
                        lastNameMSG.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    
    @IBAction func nationalIDChanged(_ sender: Any) {
        if let nationalID = nationalIDTextField.text
                {
                    if let errorMessage = invalidID(nationalID)
                    {
                        nationalIDMSG.text = errorMessage
                        nationalIDMSG.isHidden = false
                    }
                    else
                    {
                        nationalIDMSG.isHidden = true
                    }
                }
                checkForValidForm()
    }
    
    func invalidID(_ value: String) -> String?
        {
            let set = CharacterSet(charactersIn: value)
            if !CharacterSet.decimalDigits.isSuperset(of: set)
            {
                return "يجب ان لا يحتوي على احرف"
            }
            
            if value.count != 10
            {
                return "الرجاء ادخال سجل مدني صحيح"
            }
            return nil
        }
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTextField.text
                {
                    if let errorMessage = invalidEmail(email)
                    {
                        emailMSG.text = errorMessage
                        emailMSG.isHidden = false
                    }
                    else
                    {
                        emailMSG.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
        {
            let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            if !predicate.evaluate(with: value)
            {
                return "الرجاء ادخال بريد الكتروني صحيح"
            }
            
            return nil
        }
    @IBAction func phoneChanged(_ sender: Any) {
        if let phoneNumber = phoneTextField.text
                {
                    if let errorMessage = invalidPhoneNumber(phoneNumber)
                    {
                        phoneMSG.text = errorMessage
                        phoneMSG.isHidden = false
                    }
                    else
                    {
                        phoneMSG.isHidden = true
                    }
                }
                checkForValidForm()
    }
    
    func invalidPhoneNumber(_ value: String) -> String?
        {
            let set = CharacterSet(charactersIn: value)
            if !CharacterSet.decimalDigits.isSuperset(of: set)
            {
                return "الرجاء ادخال رقم جوال صحيح"
            }
            
            if value.count != 10
            {
                return "الرجاء ادخال رقم جوال صحيح"
            }
            return nil
        }
    
    func checkForValidForm()
        {
            if emailMSG.isHidden && firstNameMSG.isHidden && lastNameMSG.isHidden && phoneMSG.isHidden && nationalIDMSG.isHidden
            {
                saveButton.isEnabled = true
            }
            else
            {
                saveButton.isEnabled = false
            }
        }
}
