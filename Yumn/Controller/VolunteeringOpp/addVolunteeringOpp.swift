//
//  addVolunteeringOpp.swift
//  Yumn
//
//  Created by Deema Almutairi on 15/03/2022.
//

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

class addVolunteeringOpp: UIViewController, UITextFieldDelegate{
    
    let style = styles()
    var hospitalName = ""
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var workHoursTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionView : UIView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var titleErrorMSG: UILabel!
    @IBOutlet weak var dateErrorMSG: UILabel!
    @IBOutlet weak var durationErrorMSG: UILabel!
    @IBOutlet weak var workHoursErrorMSG: UILabel!
    @IBOutlet weak var locationErrorMSG: UILabel!
    
    
    
    
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        
        
        // Description textbox
        let obs = observed()
        let root = descriptionTextbox()
        let controller = UIHostingController(rootView: root.environmentObject(obs))
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.frame = descriptionView.bounds
        
        descriptionView.addSubview(controller.view)
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
        
        genderButtons(button: femaleButton)
        genderButtons(button: maleButton)
        
        dateTextField.inputView = dateTimePicker.inputView
        workHoursTextField.inputView = timePicker.inputView
        
    }
    
    func style(TextField : UITextField){
        TextField.delegate = self
        normalStyle(TextField)
    }
    
    func normalStyle(_ TextField : UITextField){
        style.normalStyle(TextField: TextField)
    }
    
    func activeStyle(_ TextField : UITextField){
        style.activeModeStyle(TextField: TextField)
    }
    
    func turnTextFieldTextfieldToRed(_ textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    
    func genderButtons(button : UIButton){
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        
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
    
    func genderSELECTED(button : UIButton){
        button.isSelected = true
        button.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
    }
    func genderNotSELECTED(button : UIButton){
        button.isSelected = false
        button.backgroundColor = UIColor.white
    }
    
    @IBAction func FemaleSelected(_ sender: Any) {
        if(!femaleButton.isSelected){
            genderSELECTED(button: femaleButton)
        }
        else {
            genderNotSELECTED(button: femaleButton)
        }
    }
    
    @IBAction func MaleSelected(_ sender: Any) {
        if(!maleButton.isSelected){
            genderSELECTED(button: maleButton)
        }
        else {
            genderNotSELECTED(button: maleButton)
            
        }
    }
    
    
    // MARK: - Validation
    
    //Title validation
    @IBAction func titleChanged(_ sender: Any) {
        if let title = titleTextField.text
        {
            if let errorMessage = invalidTitle(title)
            {
                titleErrorMSG.text = errorMessage
                titleErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(titleTextField)
            }
            else
            {
                titleErrorMSG.isHidden = true
                Constants.VolunteeringOpp.title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                activeStyle(titleTextField)
                print(Constants.VolunteeringOpp.description)
            }
        }
                checkForValidForm()
    }
    
    func invalidTitle(_ value: String) -> String? {
        let set = CharacterSet(charactersIn: value)
        
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        // Not TEXT
        if CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "يجب ان يحتوي على احرف فقط"
        }
        
        // Invalid length
        if value.count < 4 || value.count > 50
        {
            return "الرجاء ادخال عنوان صحيح"
        }
        return nil
    }
    
    // Date Validation
    
    
    
    // Final Validation
    func checkForValidForm()
    {
        if titleErrorMSG.isHidden && dateErrorMSG.isHidden && durationErrorMSG.isHidden && workHoursErrorMSG.isHidden && locationErrorMSG.isHidden
        {
            addButton.isEnabled = true
        }
        else
        {
            addButton.isEnabled = false
        }
    }
    
    
    // MARK: - Date and Time textfield
    
    private lazy var dateTimePicker : DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [ weak self ] (startDate , endDate) in
            let text = Date.buildDateRangeString(startDate: startDate, endDate: endDate)
            self?.dateTextField.text = text
        }
        return picker
    }()
    
    private lazy var timePicker : TimePicker = {
        let picker = TimePicker()
        picker.setup()
        picker.didSelectTimes = { [ weak self ] (startTime , endTime) in
            let text = Date.buildTimeRangeString(startTime: startTime, endTime: endTime)
            self?.workHoursTextField.text = text
        }
        return picker
    }()
    
    // MARK: - Backend
    
    @IBAction func add(_ sender: Any) {
        // User was creted successfully, store the information
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user?.uid

        // 1. get the Doc
        let docRef = db.collection("hospitalsInformation").document(uid!)
        
        // 2. to get live data
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            guard let hospitalName = data["name"] as? String else {
                return
            }
//            guard let phone = data["phone"] as? String else {
//                return
//            }

            DispatchQueue.main.async {
                self?.hospitalName = hospitalName
//                self?.hospitalPhone = phone
                
            }
        }
        
        
        
        
        var gender = ""
        if (femaleButton.isSelected){
            gender = "F"
            
            if (maleButton.isSelected){
                gender += "& M"
            }
        } else {
            gender = "M"
        }
        
        

        // Volunteer collection
        db.collection("volunteeringOpp").document().setData([
            "title":Constants.VolunteeringOpp.title,
            "date": Constants.VolunteeringOpp.date,
            "duration": Constants.VolunteeringOpp.duration,
            "workingHours": Constants.VolunteeringOpp.workingHours,
            "location": Constants.VolunteeringOpp.location,
            "description": Constants.VolunteeringOpp.description,
            "gender": gender,
            "hospitalName": hospitalName,
            "posted_by": uid!]){ error in
                
                if error != nil {
                    print(error?.localizedDescription as Any)
                    print ("error in adding the data")
                }
            }
        
    
    }
    
    
    
}
