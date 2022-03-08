//
//  VSignUpViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 07/02/2022.
//

import FirebaseAuth
import Firebase
import UIKit


class VSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loadingGif: UIImageView!
    
    
    @IBOutlet weak var blurredView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMessage: UILabel!
    
    @IBOutlet weak var popupButton: UIButton!
    
    @IBOutlet weak var popupStack: UIStackView!
    
    
    
    //    @IBOutlet weak var firstNamelabel: UILabel!
    //
    //    @IBOutlet weak var lastNameLabel: UILabel!
    //
    //
    //    @IBOutlet weak var emailLabel: UILabel!
    //
    //
    //    @IBOutlet weak var phoneLabel: UILabel!
    //
    //
    //    @IBOutlet weak var dateLabel: UILabel!
    //
    //    @IBOutlet weak var passwordLabel: UILabel!
    //
    //
    //    @IBOutlet weak var idLabel: UILabel!
    
    //    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    //    @IBOutlet weak var stackView: UIStackView!
    
    
    //    @IBOutlet weak var backButton: UIButton!
    //
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    //    //The new interface trial
    //    @IBOutlet weak var whiteView: UITextField!
    
    @IBOutlet weak var backView: UIView!
    
    
    let style = styles()
    var gender = "f"
    
    //    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var eyeButton: UIButton!
    
    
    @IBOutlet weak var passwordStrength: UIProgressView!
    
    @IBOutlet weak var containsCapAndSmallLabel: UILabel!
    @IBOutlet weak var containsCharLabel: UILabel!
    @IBOutlet weak var containsNumLabel: UILabel!
    @IBOutlet weak var charNumLabel: UILabel!
    
    @IBOutlet weak var capAndSmallLetterIcon: UIImageView!
    @IBOutlet weak var charNumIcon: UIImageView!
    @IBOutlet weak var containsSpecialIcon: UIImageView!
    @IBOutlet weak var containsNumsIcon: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // With Picker
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var bloodTypeTexfield: UITextField!
    
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    @IBOutlet weak var idError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var dateError: UILabel!
    @IBOutlet weak var cityError: UILabel!
    @IBOutlet weak var bloodError: UILabel!
    @IBOutlet weak var weightError: UILabel!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    let thePicker = UIPickerView()
    //    let thePicker2 = UIPickerView()
    
    let bloodList = ["","O+", "O-", "AB+", "AB-", "B-", "B+", "A+", "A-" , "لا أعلم"]
    let cityList = ["الرياض", "مكة المكرمة","المدينة المنورة","جدة","تبوك","نجران","الطائف","ينبع","الخبر","الدمام","حائل","الباحة","ضباء","الأحساء", "جازان"]
    let weightList = ["", "أقل من ٥٠ كج", "٥٠ كج أو أعلى"]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.navigationBar.layer.shadowOpacity = 0
        
        setUpElements()
        
        popupStack.superview?.bringSubviewToFront(popupStack)
        popupView.layer.cornerRadius = 35
        popupButton.layer.cornerRadius = 20
        
        loadingGif.loadGif(name: "yumnLoading")
        
        //validator links
        firstNameTextField.addTarget(self, action: #selector(validateFirstName(textfield:)), for: .allEvents)
        lastNameTextField.addTarget(self, action: #selector(validateLastName(textfield:)), for: .allEvents)
        idTextField.addTarget(self, action: #selector(validateID(textfield:)), for: .allEvents)
        emailTextField.addTarget(self, action: #selector(validateEmail(textfield:)), for: .allEvents)
        phoneTextField.addTarget(self, action: #selector(validatePhone(textfield:)), for: .allEvents)
        passwordTextField.addTarget(self, action: #selector(validatePassword(textfield:)), for: .allEvents)
        
        dateTextField.addTarget(self, action: #selector(validateDate(textfield:)), for: .allEvents)
        bloodTypeTexfield.addTarget(self, action: #selector(validateBlood(textfield:)), for: .allEvents)
        weightTextfield.addTarget(self, action: #selector(validateWeight(textfield:)), for: .allEvents)
        cityTextfield.addTarget(self, action: #selector(validateCity(textfield:)), for: .allEvents)
        
        genderButtons(button: femaleButton)
        genderButtons(button: maleButton)
    }
    
    
    // added for top bar
    
    //    override func viewWillAppear(_ animated: Bool) {
    ////        self.navigationController?.navigationBar.tintColor = UIColor.white
    //        super.viewWillAppear(animated)
    //
    //        var nav = self.navigationController?.navigationBar
    //        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
    //            fatalError("""
    //                Failed to load the "Tajawal" font.
    //                Make sure the font file is included in the project and the font name is spelled correctly.
    //                """
    //            )
    //        }
    //
    //        nav?.tintColor = UIColor.white
    //        nav?.barTintColor = UIColor.init(named: "mainLight")
    //        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
    //        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        var nav = self.navigationController?.navigationBar
    //        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
    //            fatalError("""
    //                Failed to load the "Tajawal" font.
    //                Make sure the font file is included in the project and the font name is spelled correctly.
    //                """
    //            )
    //        }
    //        nav?.tintColor = UIColor.init(named: "mainLight")
    //        nav?.barTintColor = UIColor.init(named: "mainLight")
    //        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
    //    }
    
    
    // MARK: - SETUP
    
    func setUpElements(){
        backView.layer.cornerRadius = 45
        dateTextField.text = ""
        thePicker.delegate = self
        hideErrorMSGs()
        
        signUpButton.layer.cornerRadius = 45
        signUpButton.layer.backgroundColor = UIColor(red: 56/225, green: 97/225, blue: 93/225, alpha: 1).cgColor
        
        
        eyeButton.bringSubviewToFront(eyeButton)
        
        //styling the eye toggle button
        let icon = UIImage(systemName: "eye.slash")
        eyeButton.setImage(icon, for: .normal)
        eyeButton.tintColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00)
        
        
        passwordTextField.sendSubviewToBack(passwordTextField)
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        
        createDatePicker()
        
        bloodTypeTexfield.inputView = thePicker
        cityTextfield.inputView = thePicker
        weightTextfield.inputView = thePicker
        
        
        // Styling up the textfields
        style(textfield: firstNameTextField)
        style(textfield: lastNameTextField)
        style(textfield: idTextField)
        style(textfield: emailTextField)
        style(textfield: phoneTextField)
        style(textfield: passwordTextField)
        
        style(textfield: dateTextField)
        style(textfield: cityTextfield)
        style(textfield: bloodTypeTexfield)
        style(textfield: weightTextfield)
        
        
        //Set the icons of the password validation
        capAndSmallLetterIcon.image = UIImage(systemName: "multiply.circle")
        capAndSmallLetterIcon.tintColor = UIColor.lightGray
        
        charNumIcon.image = UIImage(systemName: "multiply.circle")
        charNumIcon.tintColor = UIColor.lightGray
        
        containsNumsIcon.image = UIImage(systemName: "multiply.circle")
        containsNumsIcon.tintColor = UIColor.lightGray
        
        containsSpecialIcon.image = UIImage(systemName: "multiply.circle")
        containsSpecialIcon.tintColor = UIColor.lightGray
        
        //        //The new view
        //        whiteView.layer.cornerRadius = 35
        
    }
    
    func hideErrorMSGs(){
        firstNameError.isHidden = true
        lastNameError.isHidden = true
        idError.isHidden = true
        emailError.isHidden = true
        phoneNumberError.isHidden = true
        passwordError.isHidden = true
        
        dateError.isHidden = true
        cityError.isHidden = true
        bloodError.isHidden = true
        weightError.isHidden = true
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
    
    
    func createDatePicker(){
        addToolBar(dateTextField)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        // Today's Date
        datePicker.maximumDate = Date()
        dateTextField.inputView = datePicker
        
    }
    
    @objc func donePressed(){
        //  cityTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func formaDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter.string(from: date)
    }
    
    // why string?
    @objc func dateChange(datePicker: UIDatePicker){
        dateTextField.text = String(formaDate(date: datePicker.date))
    }
    
    // MARK: - Style
    
    func style(textfield : UITextField){
        textfield.delegate = self
        style.normalStyle(TextField: textfield)
    }
    
    func genderButtons(button : UIButton){
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        //        button.setTitleColor(.black, for: .normal)
        
    }
    
    @objc func turnTextFieldTextfieldToRed(textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    
    func turnTextFieldTextfieldToNormal(textfield: UITextField){
        style.normalStyle(TextField: textfield)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        if textField == self.bloodTypeTexfield {
        //            self.thePicker.isHidden = false
        //            //if you don't want the users to se the keyboard type:
        //
        //            textField.endEditing(true)
        //        }
    }
    
    @IBAction func femaleSelected(_ sender: Any) {
        femaleButton.isSelected = true
        femaleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        maleButton.isSelected = false
        maleButton.backgroundColor = UIColor.white
        
        gender = "f"
        Constants.Globals.gender = "f"
    }
    
    @IBAction func maleSelected(_ sender: Any) {
        maleButton.isSelected = true
        maleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        femaleButton.isSelected = false
        femaleButton.backgroundColor = UIColor.white
        
        gender = "m"
        Constants.Globals.gender = "m"
    }
    
    
    // MARK: - Validation
    
    
    // First name validation
    @objc func validateFirstName(textfield: UITextField){
        
        // Maximum Length
        if (textfield.text!.count >= 16) {
            firstNameError.isHidden = false
            firstNameError.text = "الاسم الأول يجب أن لا يتجاوز ١٦ حرفا"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
            //            firstNamelabel.alpha = 1
        }
        // Required
        else if (textfield.text!.count == 0) {
            firstNameError.isHidden = false
            firstNameError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
            //            firstNamelabel.alpha = 0
        }
        
        // Only letters
        else if (!isNameValid(textfield.text!)){
            firstNameError.isHidden = false
            firstNameError.text = "الاسم الأول يجب أن يتكون من أحرف فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
            //            firstNamelabel.alpha = 1
        }
        
        // Everything is fine
        else {
            firstNameError.isHidden = true
            // White space so that the layout is not affected; however, trim it in the validation
            //            firstNameError.text="  "
            turnTextFieldTextfieldToNormal(textfield: firstNameTextField)
            //            firstNamelabel.alpha = 1
            Constants.Globals.firstName = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // Last name validation
    @objc func validateLastName(textfield: UITextField){
        
        // Maximum Length
        if (textfield.text!.count >= 16) {
            lastNameError.isHidden = false
            lastNameError.text = "اسم العائلة يجب أن لا يتجاوز ١٦ حرفا"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
        }
        
        // Required
        else if (textfield.text!.count == 0) {
            lastNameError.isHidden = false
            lastNameError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
        }
        // ONly letters
        else if (!isNameValid(textfield.text!)){
            lastNameError.isHidden = false
            lastNameError.text = "اسم العائلة يجب أن يتكون من أحرف فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
        }
        
        // Everything is fine
        else {
            lastNameError.isHidden = true
            // Turn the textfield to Normal
            turnTextFieldTextfieldToNormal(textfield: lastNameTextField)
            Constants.Globals.lastName = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    // ID validation
    @objc func validateID(textfield: UITextField){
        // Required
        if (textfield.text!.count == 0) {
            idError.isHidden = false
            idError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: idTextField)
        }
        // Only numbers
        else if (!isStringAnInt(textfield.text!)){
            idError.isHidden = false
            idError.text = "رقم الأحوال المدنية/الإقامة يجب أن يتكون من أرقام فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: idTextField)
        }
        
        // Maximum Length
        else if (textfield.text!.count >= 11) {
            idError.isHidden = false
            idError.text = "رقم الأحوال المدنية/الإقامة يجب أن لا يتجاوز ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: idTextField)
            
        }
        
        // Minimum Length
        else if (textfield.text!.count < 10) {
            idError.isHidden = false
            idError.text = "رقم الأحوال المدنية/الإقامة يجب أن لا يقل عن ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: idTextField)
        }
        // Everything is fine
        else {
            idError.isHidden = true
            style(textfield: idTextField)
            Constants.Globals.id = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // Email validation
    @objc func validateEmail(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.count == 0) {
            emailError.isHidden = false
            emailError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
        }
        // Email format
        else if (!isEmailValid(textfield.text!)){
            emailError.isHidden = false
            emailError.text = "البريد الالكتروني غير صالح"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
        }
        else
        {
            isEmailTaken()
            emailError.isHidden = true
            turnTextFieldTextfieldToNormal(textfield: emailTextField)
            Constants.Globals.email = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        }
        
        
    }
    
    // Date validation
    @objc func validateDate(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            dateError.isHidden = false
            dateError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: dateTextField)
        }
        
        
        // Everything is fine
        else {
            dateError.isHidden = true
            style(textfield: dateTextField)
            let date = dateTextField.text!.prefix(10)
            Constants.Globals.birthdate = date.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    // Phone validation
    @objc func validatePhone(textfield: UITextField){
        
        // Required
        if (textfield.text!.count == 0) {
            phoneNumberError.isHidden = false
            phoneNumberError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            //            phoneLabel.alpha = 0
            
        }
        // Phone number should start with 05
        if ((!(textfield.text!.prefix(2) == "05")) && (!(textfield.text!.prefix(2) == "٠٥"))){
            phoneNumberError.isHidden = false
            phoneNumberError.text = "رقم الجوال يجب أن يبدأ ب ٠٥"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            //            phoneLabel.alpha = 1
            
        }
        // Only numbers
        else if (!isStringAnInt(textfield.text!)){
            phoneNumberError.isHidden = false
            phoneNumberError.text = "رقم الجوال يجب أن يتكون من أرقام فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            //            phoneLabel.alpha = 1
            
        }
        
        
        // Maximum Length
        else if (textfield.text!.count >= 11) {
            phoneNumberError.isHidden = false
            phoneNumberError.text = "رقم الجوال يجب أن لا يتجاوز ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            //            phoneLabel.alpha = 1
            
        }
        
        
        // Minimum Length
        else if (textfield.text!.count < 10) {
            phoneNumberError.isHidden = false
            phoneNumberError.text = "رقم الجوال يجب أن لا يقل عن ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            //            phoneLabel.alpha = 1
            
        }
        
        // Everything is fine
        else {
            phoneNumberError.isHidden = true
            // White space so that the layout is not affected; however, trim it in the validation
            phoneNumberError.text="  "
            style(textfield: phoneTextField)
            //            phoneLabel.alpha = 1
            
            Constants.Globals.phone = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    
    @objc func isEmailTaken(){
        
        Auth.auth().fetchSignInMethods(forEmail: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), completion: {
            (providers, error) in
            
            if let error = error {
                self.emailError.isHidden = true
                print ("email doesn't exist")
                print(error.localizedDescription)
                
            } else if let providers = providers {
                print(providers)
                
                print("email exists")
                self.emailError.isHidden = false
                self.emailError.text = "البريد الالكتروني مستخدم"
                // Turn the textfield to red
                self.turnTextFieldTextfieldToRed(textfield: self.emailTextField)
            }
        } )
    }
    
    
    // Name validation
    func isNameValid(_ name : String) -> Bool{
        let nameTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-zء-ي]+$")
        return nameTest.evaluate(with: name)
    }
    
    // Vlidation for Arabic or English Numbers used for ID and Phone
    func isStringAnInt(_ id: String) -> Bool {
        let idTest = NSPredicate(format: "SELF MATCHES %@", "^[٠-٩]+$")
        return idTest.evaluate(with: id) || Int(id) != nil
    }
    
    
    
    // Email format validation
    func isEmailValid(_ email : String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: email)
    }
    
    var passordCriteria = [0,0,0,0]
    var isPasswordStrong = false
    
    // Password validation
    @objc func validatePassword(textfield: UITextField){
        
        
        
        // Required
        if (textfield.text!.isEmpty) {
            passwordError.isHidden = false
            passwordError.text = "اجباري"
            //            passwordLabel.alpha = 0
            passordCriteria[0] = 0
            passordCriteria[1] = 0
            passordCriteria[2] = 0
            passordCriteria[3] = 0
            
            
            
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: passwordTextField)
            
            containsNumLabel.textColor = UIColor.red
            containsCharLabel.textColor = UIColor.red
            charNumLabel.textColor = UIColor.red
            containsCapAndSmallLabel.textColor = UIColor.red
            
            capAndSmallLetterIcon.tintColor = UIColor.red
            containsNumsIcon.tintColor = UIColor.red
            containsSpecialIcon.tintColor = UIColor.red
            charNumIcon.tintColor = UIColor.red
            
        }
        
        
        // Not Empty
        else if (!(textfield.text!.isEmpty)){
            
            // Minimum Length
            if (textfield.text!.count < 8) {
                // Change the x label to red
                
                //Remove the label
                passwordError.text="  "
                //Change the label and the icon to red
                charNumIcon.image = UIImage(systemName: "multiply.circle")
                charNumIcon.tintColor = UIColor.red
                charNumLabel.textColor = UIColor.red
                
                
                
                
                // Turn the textfield to red
                turnTextFieldTextfieldToRed(textfield: passwordTextField)
                // change the count of the password strength
                passordCriteria[0] = 0
            }
            
            else {
                //Change the label to green
                charNumLabel.textColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
                // change the count of the password strength
                passordCriteria[0] = 1
                // Change the icon to check
                charNumIcon.image = UIImage(systemName: "checkmark.circle")
                charNumIcon.tintColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
                
                
                
            }
            
            
            // Check if the password contains numbers
            let decimalCharacters = CharacterSet.decimalDigits
            
            let decimalRange = textfield.text!.rangeOfCharacter(from: decimalCharacters)
            
            if (decimalRange == nil){
                //Remove the label
                passwordError.text="الرقم السري ضعيف"
                //Change the label to red
                containsNumLabel.textColor = UIColor.red
                // Turn the textfield to green
                turnTextFieldTextfieldToRed(textfield: passwordTextField)
                // change the count of the password strength
                passordCriteria[1] = 0
                //Change the icon to red
                containsNumsIcon.image = UIImage(systemName: "multiply.circle")
                containsNumsIcon.tintColor = UIColor.red
            }
            
            else {
                //Change the label to green
                containsNumLabel.textColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
                // change the count of the password strength
                passordCriteria[1] = 1
                // Change the icon to check
                containsNumsIcon.image = UIImage(systemName: "checkmark.circle")
                containsNumsIcon.tintColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
            }
            
            
            
            // Check if the password contains special characters
            if (!containsSpecialCharacter(textfield.text!)){
                
                //Remove the label
                passwordError.text="  "
                //Change the label to red
                containsCharLabel.textColor = UIColor.red
                // Turn the textfield to green
                turnTextFieldTextfieldToRed(textfield: passwordTextField)
                // change the count of the password strength
                passordCriteria[2] = 0
                //Change the icon to red
                containsSpecialIcon.image = UIImage(systemName: "multiply.circle")
                containsSpecialIcon.tintColor = UIColor.red
            }
            
            else {
                //Change the label to green
                containsCharLabel.textColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
                // change the count of the password strength
                passordCriteria[2] = 1
                // Change the icon to check
                containsSpecialIcon.image = UIImage(systemName: "checkmark.circle")
                containsSpecialIcon.tintColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
            }
            
            
            
            
            
            // Check if the password contains Upper and Lower case
            if (!containsLowerAndUpper(textfield.text!)){
                
                //Remove the label
                passwordError.text="  "
                //Change the label to green
                containsCapAndSmallLabel.textColor = UIColor.red
                // Turn the textfield to green
                turnTextFieldTextfieldToRed(textfield: passwordTextField)
                // change the count of the password strength
                passordCriteria[3] = 0
                //Change the icon to red
                capAndSmallLetterIcon.image = UIImage(systemName: "multiply.circle")
                capAndSmallLetterIcon.tintColor = UIColor.red
            }
            
            else {
                //Change the label to green
                containsCapAndSmallLabel.textColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
                // change the count of the password strength
                passordCriteria[3] = 1
                // Change the icon to check
                capAndSmallLetterIcon.image = UIImage(systemName: "checkmark.circle")
                capAndSmallLetterIcon.tintColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
            }
            
            
        } // Password criteria validation
        
        
        // Everything is fine and the password is strong
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            passwordError.isHidden = true
            style(textfield: passwordTextField)
        }
        
        if (passordCriteria[0]+passordCriteria[1]+passordCriteria[2]+passordCriteria[3] == 4){
            // White space so that the layout is not affected; however, trim it in the validation
            passwordError.isHidden = true
            style(textfield: passwordTextField)
            Constants.Globals.password = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        }
        
        
        
        if (passordCriteria[0]+passordCriteria[1]+passordCriteria[2]+passordCriteria[3] == 1){
            passwordStrength.progress = 0.25
            passwordStrength.progressTintColor = .red
            isPasswordStrong = false
            passwordError.text="الرقم السري ضعيف"
            
            
        }
        
        else if  (passordCriteria[0]+passordCriteria[1]+passordCriteria[2]+passordCriteria[3] == 2){
            passwordStrength.progress = 0.5
            passwordStrength.progressTintColor = .orange
            isPasswordStrong = false
            passwordError.text="الرقم السري ضعيف"
            
        }
        
        
        else if  (passordCriteria[0]+passordCriteria[1]+passordCriteria[2]+passordCriteria[3] == 3){
            passwordStrength.progress = 0.75
            passwordStrength.progressTintColor = .yellow
            isPasswordStrong = false
            passwordError.text="الرقم السري ضعيف"
            
        }
        
        else if  (passordCriteria[0]+passordCriteria[1]+passordCriteria[2]+passordCriteria[3] == 4){
            passwordStrength.progress = 1
            passwordStrength.progressTintColor = UIColor(red: 0, green: 150/255, blue: 0, alpha: 1)
            isPasswordStrong = true
            
        }
        
        
        else {
            passwordStrength.progress = 0
            if(!(textfield.text!.isEmpty)){
                passwordError.text = "الرقم السري ضعيف"
            }
        }
        
    }
    
    
    
    // Check if the password constains capital and small letters
    func containsLowerAndUpper(_ pass : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        
        
        
        return texttest.evaluate(with: pass) && texttest2.evaluate(with: pass)
    }
    
    // Check if the password constains special character
    func containsSpecialCharacter(_ pass : String) -> Bool{
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: pass)
    }
    
    
    // City validation
    @objc func validateCity(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            cityError.isHidden = false
            cityError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: cityTextfield)
            //            cityLabel.alpha = 0
        }
        
        // Everything is fine
        else {
            cityError.isHidden = true
            style(textfield: cityTextfield)
            let city = textfield.text!.prefix(8)
            Constants.Globals.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    
    // weight validation
    @objc func validateWeight(textfield: UITextField){
        
        
        // Required
        if (textfield.text!.isEmpty) {
            weightError.isHidden = false
            weightError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: weightTextfield)
        }
        
        // Everything is fine
        else {
            weightError.isHidden = true
            style(textfield: weightTextfield)
            let weight = textfield.text!.prefix(14)
            Constants.Globals.weight = weight.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // blood type validation
    @objc func validateBlood(textfield: UITextField){
        
        // Required
        if (textfield.text!.isEmpty) {
            bloodError.isHidden = false
            bloodError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: bloodTypeTexfield)
        }
        // White space so that the layout is not affected; however, trim it in the validation
        else {
            bloodError.isHidden = true
            style(textfield: bloodTypeTexfield)
            let blood = textfield.text!.prefix(2)
            Constants.Globals.bloodType = blood.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    @IBAction func onEyeTapped(_ sender: Any) {
        
        
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
    
    
    
    
    // MARK: - Backend
    //
    //    @IBAction func onPressedCont(_ sender: Any) {
    //
    //
    //        //chc if not empty
    //
    //        // Cont...
    //    }
    
    
    //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    //
    //        var allValidations = firstNameError.text! + lastNameError.text! + idError.text! + emailError.text! + phoneNumberError.text!
    //
    //
    //        // Did not include the password here since I will check it down
    //        allValidations += dateError.text!
    //
    //
    //        // Just for testing
    //        let check = ((allValidations.trimmingCharacters(in: .whitespacesAndNewlines)))
    //        print (check)
    //
    //
    //
    //        // If all the fields are filled and valid and the password is strong
    //        if (isPasswordStrong == true && check == ""){
    //            return true
    //        }
    //
    //        // If all the fields are filled and valid but the password is weak/empty
    //        else if (isPasswordStrong == false && check == "")
    //        {
    //
    //
    //            return false
    //
    //
    //
    //
    //        }
    //
    //        else {
    //            // Textfields are not valid or password is weak/empty
    //            print ("Weak/empty pass or some textfields are not valid")
    //
    //
    //
    //            return false
    //        }
    //
    //    }
    
    
    @IBAction func onPressedSignUp(_ sender: Any) {
        
        // let check = cityError.text!.trimmingCharacters(in: .whitespacesAndNewlines) + bloodError.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Empty First name
        if (firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            firstNameError.isHidden = false
            firstNameError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
            
        }
        
        // Empty last name
        if (lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            lastNameError.isHidden = false
            lastNameError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
            
        }
        
        
        
        // Empty id
        if (idTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            idError.isHidden = false
            idError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: idTextField)
            
        }
        
        // Empty email
        if (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            emailError.isHidden = false
            emailError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: emailTextField)
            
        }
        
        
        
        // Empty phone
        if (phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            phoneNumberError.isHidden = false
            phoneNumberError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
            
        }
        
        
        
        
        // Empty birthdate
        if (dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            dateError.isHidden = false
            dateError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: dateTextField)
            
        }
        
        
        
        // Empty password
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            passwordError.isHidden = false
            passwordError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: passwordTextField)
            
        }
        
        // If all the fields are filled and valid but the password is weak/empty
        if (isPasswordStrong == false)
        {
            // just in case...
        }
        
        // City not validated
        if (cityTextfield.text!.prefix(8).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
        {
            cityError.isHidden = false
            cityError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: cityTextfield)
        }
        
        //Blood type not selected
        if (bloodTypeTexfield.text!.prefix(2).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
        {
            bloodError.isHidden = false
            bloodError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: bloodTypeTexfield)
            
            
        }
        
        // Weight not selected
        if (weightTextfield.text!.prefix(14).trimmingCharacters(in: .whitespacesAndNewlines) == "")
            
            
        {
            weightError.isHidden = false
            weightError.text! = "إجباري"
            turnTextFieldTextfieldToRed(textfield: weightTextfield)
            
        }
        
        
        else if (cityError.isHidden && bloodError.isHidden) {
            
            
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
                        
                        self.blurredView.isHidden = false
                        self.popupView.isHidden = false
                        self.popupTitle.text = "خطأ في الشبكة"
                        self.popupMessage.text = "الرجاء التحقق من الاتصال بالشبكة"
                    }
                    
                    // Couldn't create the user
                    else {
                        
                        self.blurredView.isHidden = false
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
        blurredView.isHidden = true
    }
    
    
}


extension VSignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
}
