//
//  HospitalProfileViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 19/02/2022.
//
import SCLAlertView
import Foundation
import FirebaseFirestore
import UIKit

class HospitalProfileViewController: UIViewController, UITextFieldDelegate {
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backView.layer.cornerRadius = 45
        saveButton.layer.cornerRadius = 45
        textFieldSetUP()
        
        // Read Data
        profileInfo()
        
        // Hide keyboard
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func profileInfo(){
        // 1. get the Doc
        let docRef = database.document("users/Mw9h0hFX20vyTKuplNdv")
        
        // 2. to get live data
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            guard let hospitalName = data["hospitalName"] as? String else {
                return
            }
            guard let phone = data["phone"] as? Int else {
                return
            }
            
            DispatchQueue.main.async {
                // Assign the values here
                self?.hospitalTextField.text = hospitalName
                self?.phoneTextField.text = String(phone)
                
            }
        }
    }
    
    func textFieldSetUP(){
        textFieldStyle(TextField: hospitalTextField)
        textFieldStyle(TextField: phoneTextField)
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
    
    @IBAction func Update(_ sender: Any) {
        //         get the Doc
        let docRef = database.document("users/Mw9h0hFX20vyTKuplNdv")
        
        // save data
        docRef.setData(["hospitalName": hospitalTextField.text!,
                        "phone": Int(phoneTextField.text!)!,
                        "uid":"Mw9h0hFX20vyTKuplNdv",
                        "userType":"Hospital"
                       ])
        SCLAlertView().showSuccess("Success", subTitle: "تم حفظ التغييرات بنجاح")
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


