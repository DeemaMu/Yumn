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
    let style = styles()
    var points = 0
    
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var backView: UIView!
    let blue = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1)

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
    let weight = ["أقل من ٥٠ كج", "٥٠ كج أو أعلى"]
    
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
        viewWillAppear(true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        guard let customFont = UIFont(name: "Tajawal", size: 19) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        saveButton.setAttributedTitle(NSAttributedString(string: "حفظ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
//        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
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
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if birthdateTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if weightTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
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
        if(!enabeld){
            saveButton.layer.cornerRadius = 29
            saveButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
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
        style.normalStyle(TextField: TextField)
    }
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        style.activeModeStyle(TextField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        style.normalStyle(TextField: textField)
    }
    
    func activeStyle(textfield : UITextField){
        style.activeModeStyle(TextField: textfield)
    }
    
    func turnTextFieldTextfieldToRed(textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    func turnTextFieldTextfieldToNormal(textfield: UITextField){
        style.normalStyle(TextField: textfield)
    }
    // Get Profile info
    func profileInfo(){
        
        let user = Auth.auth().currentUser
        let uid = user?.uid

        
        // 1. get the Doc
        let docRef = database.collection("volunteer").document(uid!)
        
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
        
        
        if Auth.auth().currentUser != nil {
            // User is signed in.

            let user = Auth.auth().currentUser
            let uid = user?.uid

            var gender = "m"
            if (femaleButton.isSelected){
                gender = "f"
            }

            // get the Doc
            let docRef = database.collection("volunteer").document(uid!)
        
            // save data
            docRef.updateData(["firstName": nameTextField.text!,
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
                            "uid" : uid!,
                            "userType" : "Volunteer"]){ error in

                if error != nil {
                    print(error?.localizedDescription as Any)
                    // Show error message or pop up message
                    print ("error in saving the volunteer data")

                }
            }
            if (emailTextField.text != user?.email){
                user?.updateEmail(to: emailTextField.text!) { error in
                    if let error = error {
                        print(error)
                    }
                }
                
            }
        } else {
          // No user is signed in.
          print("No user")
        }
        
        // Show success message
        performSegue(withIdentifier: "vProfileUpdated", sender: self)
    }
    
    
    // Listeners
    @IBAction func firstNameChanged(_ sender: Any) {
        if let firstName = nameTextField.text
        {
            if let errorMessage = invalidName(firstName)
            {
                firstNameMSG.text = errorMessage
                firstNameMSG.isHidden = false
                turnTextFieldTextfieldToRed(textfield: nameTextField)
            }
            else
            {
                firstNameMSG.isHidden = true
                activeStyle(textfield: nameTextField)
                
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
                turnTextFieldTextfieldToRed(textfield: familyTextField)
            }
            else
            {
                lastNameMSG.isHidden = true
                activeStyle(textfield: familyTextField)
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
                turnTextFieldTextfieldToRed(textfield: nationalIDTextField)
            }
            else
            {
                nationalIDMSG.isHidden = true
                activeStyle(textfield: nationalIDTextField)
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
                turnTextFieldTextfieldToRed(textfield: emailTextField)
            }
            else
            {
                isEmailTaken()
                emailMSG.isHidden = true
                activeStyle(textfield: emailTextField)
            }
        }
        
        checkForValidForm()
    }
    
    @objc func isEmailTaken(){
        
        Auth.auth().fetchSignInMethods(forEmail: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), completion: {
            (providers, error) in
            
            if let error = error {
                self.emailMSG.isHidden = true
            } else if let providers = providers {
                self.emailMSG.isHidden = false
                self.emailMSG.text = "البريد الالكتروني مستخدم"
                self.turnTextFieldTextfieldToRed(textfield: self.emailTextField)
            }
        } )
    }
    
    @IBAction func phoneChanged(_ sender: Any) {
        if let phoneNumber = phoneTextField.text
        {
            if let errorMessage = invalidPhoneNumber(phoneNumber)
            {
                phoneMSG.text = errorMessage
                phoneMSG.isHidden = false
                turnTextFieldTextfieldToRed(textfield: phoneTextField)
            }
            else
            {
                phoneMSG.isHidden = true
                activeStyle(textfield: phoneTextField)
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
