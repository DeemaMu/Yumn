//
//  addVolunteeringOpp.swift
//  Yumn
//
//  Created by Deema Almutairi on 15/03/2022.
//

import Foundation
import UIKit

class addVolunteeringOpp: UIViewController, UITextFieldDelegate{
    
    let style = styles()
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var workHoursTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    //Need Style
    @IBOutlet weak var descriptionTextBox: UITextField!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var titleErrorMSG: UILabel!
    @IBOutlet weak var dateErrorMSG: UILabel!
    @IBOutlet weak var durationErrorMSG: UILabel!
    @IBOutlet weak var workHoursErrorMSG: UILabel!
    @IBOutlet weak var locationErrorMSG: UILabel!
    
    
    
    
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        
        //Hide
        addButton(enabeld: false)
        hideErrorMSGs()
        
        // Hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        guard let customFont = UIFont(name: "Tajawal", size: 19) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        addButton.setAttributedTitle(NSAttributedString(string: "حفظ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark")!, NSAttributedString.Key.font: customFont]
    }
    
    func setUP(){
        backView.layer.cornerRadius = 45
        addButton.layer.cornerRadius = 45
        style(TextField: titleTextField)
        style(TextField: dateTextField)
        style(TextField: durationTextField)
        style(TextField: workHoursTextField)
        style(TextField: locationTextField)
    }
    
    func style(TextField : UITextField){
        TextField.delegate = self
        normalStyle(TextField)
    }
    
    func normalStyle(_ TextField : UITextField){
        style.normalStyle(TextField: TextField)
    }
    
    func hideErrorMSGs(){
        titleErrorMSG.isHidden = true
        dateErrorMSG.isHidden = true
        durationErrorMSG.isHidden = true
        workHoursErrorMSG.isHidden = true
        locationErrorMSG.isHidden = true
    }
    
    func addButton(enabeld : Bool){
        addButton.isEnabled = enabeld
        if(!enabeld){
            addButton.layer.cornerRadius = 29
            addButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
}
