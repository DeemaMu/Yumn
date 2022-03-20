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
    @IBOutlet weak var workHoursTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionView : UIView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var titleErrorMSG: UILabel!
    @IBOutlet weak var dateErrorMSG: UILabel!
    @IBOutlet weak var workHoursErrorMSG: UILabel!
    @IBOutlet weak var locationErrorMSG: UILabel!
    @IBOutlet weak var genderErrorMSG: UILabel!
    
    
    // FOR VALIDATION
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    
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
        //        hideErrorMSGs()
        
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
        workHoursErrorMSG.isHidden = true
        locationErrorMSG.isHidden = true
        genderErrorMSG.isHidden = true
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
        genderValidation()
    }
    
    @IBAction func MaleSelected(_ sender: Any) {
        if(!maleButton.isSelected){
            genderSELECTED(button: maleButton)
        }
        else {
            genderNotSELECTED(button: maleButton)
        }
        genderValidation()
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
    
    func dateChanged() {
        if let date = dateTextField.text
        {
            if let errorMessage = invalidDate(date)
            {
                dateErrorMSG.text = errorMessage
                dateErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(dateTextField)
            }
            else
            {
                dateErrorMSG.isHidden = true
                Constants.VolunteeringOpp.date = dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                activeStyle(dateTextField)
            }
        }
        checkForValidForm()
    }
    
    func invalidDate(_ value: String) -> String? {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        // End date is before start date
        if (startDate > endDate){
            return "تاريخ النهاية يجب ان يكون بعد البداية"
        }
        
        return nil
    }
    
    // Time Validation
    func timeChanged() {
        if let time = workHoursTextField.text
        {
            if let errorMessage = invalidtime(time)
            {
                workHoursErrorMSG.text = errorMessage
                workHoursErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(workHoursTextField)
            }
            else
            {
                workHoursErrorMSG.isHidden = true
                Constants.VolunteeringOpp.workingHours = workHoursTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                activeStyle(workHoursTextField)
            }
        }
        checkForValidForm()
    }
    
    func invalidtime(_ value: String) -> String? {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        // End time is before start time
        if (formatter.date(from: startTime)! > formatter.date(from: endTime)!){
            
            return "وقت النهاية يجب ان يكون بعد البداية"
        }
        
        // End time is before start time
        if (formatter.date(from: startTime)! == formatter.date(from: endTime)!){
            
            return "وقت النهاية يجب ان لا يساوي البداية"
        }
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        let timeFormatter = DateFormatter()
          timeFormatter.dateFormat = "HH:mm"
      
        
        let todayDate = String(format: "%@", dateFormatter.string(from: today))
        let todaytime = String(format: "%@", timeFormatter.string(from: today))
        
        // if the chosen date is today, is the time valid ?
        if (startDate == todayDate){
            print ("امبيييه")

            // start time is before current time
            if (formatter.date(from: startTime)! < formatter.date(from: todaytime)!){
                
                return "هذا الوقت غير متاح"
            }
            
            // start time is equal to current time
            if (formatter.date(from: startTime)! == formatter.date(from: todaytime)!){
                
                return "هذا الوقت غير متاح"
            }
            
        }
        
        return nil
    }
    
    // location Validation
    @IBAction func locationChanged(_ sender: Any) {
        if let location = locationTextField.text
        {
            if let errorMessage = invalidLocation(location)
            {
                locationErrorMSG.text = errorMessage
                locationErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(locationTextField)
            }
            else
            {
                locationErrorMSG.isHidden = true
                Constants.VolunteeringOpp.location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                activeStyle(locationTextField)
            }
        }
        checkForValidForm()
    }
    
    func invalidLocation(_ value: String) -> String? {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        // Contains special char
        if containsSpecialCharacter(value)
        {
            return "يجب ان يحتوي على احرف او ارقام فقط"
        }
        
        // Invalid length
        if value.count < 4 || value.count > 50
        {
            return "الرجاء ادخال موقع صحيح"
        }
        return nil
    }
    
    func containsSpecialCharacter(_ value : String) -> Bool{
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: value)
    }
    
    // gender Validation
    func genderValidation(){
        if(maleButton.isSelected){
            genderErrorMSG.isHidden = true
        }
        else if(femaleButton.isSelected){
            genderErrorMSG.isHidden = true
            
        } else {
            genderErrorMSG.isHidden = false
        }
    }
    
    // Final Validation
    func checkForValidForm()
    {
        if titleErrorMSG.isHidden && dateErrorMSG.isHidden && workHoursErrorMSG.isHidden && locationErrorMSG.isHidden && genderErrorMSG.isHidden
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
            
            self?.startDate = Date.dateFormatter(date: startDate)
            self?.endDate = Date.dateFormatter(date: endDate)
            
            let text = Date.buildDateRangeString(startDate: startDate, endDate: endDate)
            self?.dateTextField.text = text
            
            // Validation Method
            self?.dateChanged()
        }
        return picker
    }()
    
    private lazy var timePicker : TimePicker = {
        let picker = TimePicker()
        picker.setup()
        picker.didSelectTimes = { [ weak self ] (startTime , endTime) in
            
            self?.startTime = Date.timeFormatter(time: startTime)
            self?.endTime = Date.timeFormatter(time: endTime)
            
            let text = Date.buildTimeRangeString(startTime: startTime, endTime: endTime)
            self?.workHoursTextField.text = text
            
            // Validation Method
            self?.timeChanged()
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
            gender = "اناث فقط"
        }
        if (maleButton.isSelected){
            gender = "ذكور فقط"
        }
        if (femaleButton.isSelected && maleButton.isSelected) {
            gender = "اناث وذكور"
        }
        let today = Date()
        
        
        // Volunteer collection
        db.collection("volunteeringOpp").document().setData([
            "title":Constants.VolunteeringOpp.title,
            "date": Constants.VolunteeringOpp.date,
            "workingHours": Constants.VolunteeringOpp.workingHours,
            "location": Constants.VolunteeringOpp.location,
            "description": Constants.VolunteeringOpp.description,
            "gender": gender,
            "hospitalName": hospitalName,
            "postDate": today,
            "posted_by": uid!]){ error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    print ("error in adding the data")
                }
            }
    }
}
