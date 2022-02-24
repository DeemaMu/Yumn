//
//  VolunteerProfileViewController.swift
//
//  Created by Deema Almutairi on 15/02/2022.
//

import SCLAlertView
import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class VolunteerProfileViewController: UIViewController, UITextFieldDelegate {
    
    let database = Firestore.firestore()
    var points = 0
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var nationalIDTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
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
    
    
    let bloodTypePicker = UIPickerView()
    let citiesPicker = UIPickerView()
    let weightPicker = UIPickerView()
    
    let bloodList = ["لا اعلم","O+", "O-", "AB+", "AB-", "B-", "B+", "A+", "A-" ]
    let cities = ["الرياض", "مكة المكرمة","المدينة المنورة","جدة","تبوك","نجران","الطائف","ينبع","الخبر","الدمام","حائل","الباحة","ضباء","الأحساء", "جازان"]
    let weight = ["اكثر من 30","اقل من 30"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        
        // Read Data
        profileInfo()
        
        // Hide 
        saveButton(enabeld: false)
        hideErrorMSGs()
        
        // Hide keyboard
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bloodTypeTextField.isFirstResponder {
            view.frame.origin.y -= 100
        }
        if birthdateTextField.isFirstResponder {
            view.frame.origin.y -= 150
        }
        if weightTextField.isFirstResponder {
            view.frame.origin.y -= 90
        }
        if cityTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification){
        if bloodTypeTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        if birthdateTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        if weightTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        if cityTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func setUP(){
        backView.layer.cornerRadius = 45
        saveButton.layer.cornerRadius = 45
        
        // Style
        style(TextField: nameTextField)
        style(TextField: familyTextField)
        style(TextField: nationalIDTextField)
        style(TextField: emailTextField)
        style(TextField: phoneTextField)
        style(TextField: bloodTypeTextField)
        style(TextField: birthdateTextField)
        style(TextField: weightTextField)
        style(TextField: cityTextField)
        
        genderButtons(button: femaleButton)
        genderButtons(button: maleButton)
        
        // PickerView
        createDatePicker()
        setupPicker(bloodTypePicker,bloodTypeTextField)
        setupPicker(citiesPicker,cityTextField)
        setupPicker(weightPicker,weightTextField)
        
    }
    
    
    // Datepicker
    func createDatePicker(){
        
        addToolBar(birthdateTextField)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        // Today's Date
        datePicker.maximumDate = Date()
        birthdateTextField.inputView = datePicker
        
    }
    func formaDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter.string(from: date)
        
    }
    
    func setupPicker(_ pickerView : UIPickerView ,_ textField : UITextField){
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        addToolBar(textField)
        
    }
    func addToolBar(_ textField : UITextField){
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "تم", style: .done, target: self, action: #selector(donePressed))
        doneButton.tintColor = UIColor.init(red: 56/255, green: 97/255, blue: 93/255, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed() {
        cityTextField.resignFirstResponder()
        bloodTypeTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func maleSELECTED(){
        maleButton.isSelected = true
        maleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        femaleButton.isSelected = false
        femaleButton.backgroundColor = UIColor.white
    }
    func femaleSELECTED(){
        femaleButton.isSelected = true
        femaleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        maleButton.isSelected = false
        maleButton.backgroundColor = UIColor.white
    }
    
    func genderButtons(button : UIButton){
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        //        button.setTitleColor(.black, for: .normal)
        
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
    
    
    func style(TextField : UITextField){
        TextField.delegate = self
        normalStyle(TextField: TextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 56/255, green: 97/255, blue: 93/255, alpha: 1).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        normalStyle(TextField: textField)
    }
    
    func normalStyle(TextField : UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        TextField.borderStyle = .none
        TextField.layer.addSublayer(bottomLine)
    }
    
    
    
    
    // Get Profile info
    func profileInfo(){
        
        // 1. get the Doc
        let docRef = database.document("volunteer/f8ppu8BUAOdRZjCjv9AiTwq1yeh2")
        
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
            guard let nationalID = data["nationalID"] as? String else {
                return
            }
            guard let email = data["email"] as? String else {
                return
            }
            guard let phone = data["phone"] as? String else {
                return
            }
            guard let gender = data["gender"] as? String else {
                return
            }
            guard let bloodType = data["bloodType"] as? String else {
                return
            }
            guard let birthdate = data["birthDate"] as? String else {
                return
            }
            guard let weight = data["weight"] as? String else {
                return
            }
            guard let city = data["city"] as? String else {
                return
            }
            guard let points = data["points"] as? Int else {
                return
            }
            DispatchQueue.main.async {
                // Assign the values here
                self?.nameTextField.text = firstName
                self?.familyTextField.text = lastName
                self?.nationalIDTextField.text = nationalID
                self?.emailTextField.text = email
                self?.phoneTextField.text = phone
                self?.bloodTypeTextField.text = bloodType
                self?.birthdateTextField.text = birthdate
                
                if (gender == "m"){
                    self?.maleSELECTED()
                } else if(gender == "f"){
                    self?.femaleSELECTED()
                }
                self?.points = points
                self?.weightTextField.text = weight
                self?.cityTextField.text = city
            }
        }
    }
  
    
    // Save updates
    @IBAction func Update(_ sender: Any) {
        
//        if Auth.auth().currentUser != nil {
//            // User is signed in.
//
//            let user = Auth.auth().currentUser
//            let uid = user?.uid
//
//            var gender = "m"
//            if (femaleButton.isSelected){
//                gender = "f"
//            }
//
//            // get the Doc
//            let docRef = database.collection("volunteer").document(uid!)
        
//            // save data
//            docRef.setData(["firstName": nameTextField.text!,
//                            "lastName": familyTextField.text!,
//                            "nationalID": nationalIDTextField.text!,
//                            "email": emailTextField.text!,
//                            "phone": phoneTextField.text!,
//                            "gender": gender,
//                            "bloodType": bloodTypeTextField.text!,
//                            "birthDate": birthdateTextField.text!,
//                            "weight": weightTextField.text!,
//                            "city": cityTextField.text!,
//                            "points": points,
//                            "uid" : uid!,
//                            "userType" : "Volunteer"]){ error in
//
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//
//                    // Show error message or pop up message
//                    print ("error in saving the volunteer data")
//
//
//                }
//            }
//        } else {
//          // No user is signed in.
//          print("No user")
//        }
        
        var gender = "m"
        if (femaleButton.isSelected){
            gender = "f"
        }
        
        // get the Doc
            let docRef = database.document("volunteer/f8ppu8BUAOdRZjCjv9AiTwq1yeh2")

        // save data
        docRef.setData(["firstName": nameTextField.text!,
                        "lastName": familyTextField.text!,
                        "nationalID": nationalIDTextField.text!,
                        "email": emailTextField.text!,
                        "phone": phoneTextField.text!,
                        "gender": gender,
                        "bloodType": bloodTypeTextField.text!,
                        "birthDate": birthdateTextField.text!,
                        "weight": weightTextField.text!,
                        "city": cityTextField.text!,
                        "points": points,
                        "uid" : "f8ppu8BUAOdRZjCjv9AiTwq1yeh2",
                        "userType" : "Volunteer"]){ error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
    
                // Show error message or pop up message
                print ("error in saving the volunteer data")
                
                
            }
        }
    }
    
    
    // Listeners
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
    
    @IBAction func femaleSelected(_ sender: Any) {
        femaleSELECTED()
        saveButton(enabeld: true)
    }
    
    @IBAction func maleSelected(_ sender: Any) {
        maleSELECTED()
        saveButton(enabeld: true)
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        birthdateTextField.text = formaDate(date: datePicker.date)
        saveButton(enabeld: true)
    }
    
    
    
    // Validation
    func invalidName(_ value: String) -> String?
    {
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
        if value.count < 2 || value.count > 30
        {
            return "الرجاء ادخال اسم صحيح"
        }
        return nil
    }
    
    func invalidID(_ value: String) -> String?
    {
        
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "يجب ان يحتوي على ارقام فقط"
        }
        
        if value.count != 10
        {
            return "الرجاء ادخال سجل مدني صحيح"
        }
        return nil
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "الرجاء ادخال بريد الكتروني صحيح"
        }
        
        return nil
    }
    
    func invalidPhoneNumber(_ value: String) -> String?
    {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
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
    
    
    
    // Final Validation
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




extension VolunteerProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (pickerView == bloodTypePicker){
            return bloodList.count
        }
        else if (pickerView == citiesPicker){
            return cities.count
        }
        else if (pickerView == weightPicker){
            return weight.count
        }
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == bloodTypePicker){
            return bloodList[row]
        }
        else if (pickerView == citiesPicker){
            return cities[row]
        }
        else if (pickerView == weightPicker){
            return weight[row]
        }
        
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == bloodTypePicker){
            bloodTypeTextField.text = bloodList[row]
            saveButton(enabeld: true)
        }
        else if (pickerView == citiesPicker){
            cityTextField.text = cities[row]
            saveButton(enabeld: true)
        }
        else if (pickerView == weightPicker){
            weightTextField.text = weight[row]
            saveButton(enabeld: true)
        }
    }
    
}
