//
//  VolunteerProfileViewController.swift
//
//  Created by Deema Almutairi on 15/02/2022.
//

import Foundation
import UIKit

class VolunteerProfileViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    
    @IBOutlet weak var nationalIDTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var sexTextField: UITextField!
    
    @IBOutlet weak var bloodTypeTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var wiegthTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backView.layer.cornerRadius = 45
        saveButton.layer.cornerRadius = 45
        textFieldSetUP()
        
    }
    
    func textFieldSetUP(){
        textFieldStyle(TextField: nameTextField)
        textFieldStyle(TextField: familyTextField)
        textFieldStyle(TextField: nationalIDTextField)
        textFieldStyle(TextField: emailTextField)
        textFieldStyle(TextField: phoneTextField)
        textFieldStyle(TextField: sexTextField)
        textFieldStyle(TextField: bloodTypeTextField)
        textFieldStyle(TextField: birthdayTextField)
        textFieldStyle(TextField: wiegthTextField)
        textFieldStyle(TextField: cityTextField)
    }
    
    func textFieldStyle(TextField : UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 2, width: TextField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        
        TextField.borderStyle = .none
        
        TextField.layer.addSublayer(bottomLine)
//        TextField.font = UIFont(name: "Tajawal-Regular", size: 18)!
    }
    
}
