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
    
//    @IBOutlet weak var popUpStack: UIStackView!
//
//    @IBOutlet weak var blackBlurredView: UIView!
//
//    @IBOutlet weak var popUpView: UIView!
//
//    @IBOutlet weak var popUpButton: UIButton!
//
//    @IBOutlet weak var popUpMessage: UILabel!
//
//    @IBOutlet weak var popUpTitle: UILabel!
    
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
    //    @IBOutlet weak var stepper1: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    

    let style = styles()
    var gender = "f"
    
//    @IBOutlet weak var topNavBar: UINavigationBar!
    
    
//    @IBOutlet weak var eyeButton: UIButton!
  
    
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
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    @IBOutlet weak var idError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var dateError: UILabel!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var contButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        stepper1.image = UIImage(named: "stepper 1:2")
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0
  
        setUpElements()

        
//        popUpStack.superview?.bringSubviewToFront(popUpStack)
//        popUpView.layer.cornerRadius = 20
//        popUpButton.layer.cornerRadius = 20

        
        // First name validator link
        firstNameTextField.addTarget(self, action: #selector(validateFirstName(textfield:)), for: .editingChanged)
        
        
        // Last name validator link
        lastNameTextField.addTarget(self, action: #selector(validateLastName(textfield:)), for: .editingChanged)
        
        
        // ID validator link
        idTextField.addTarget(self, action: #selector(validateID(textfield:)), for: .editingChanged)
        
        
        // Email validator link
        emailTextField.addTarget(self, action: #selector(validateEmail(textfield:)), for: .editingChanged)
        
        // Phone validator link
        phoneTextField.addTarget(self, action: #selector(validatePhone(textfield:)), for: .editingChanged)
        
        // Password validator link
        passwordTextField.addTarget(self, action: #selector(validatePassword(textfield:)), for: .editingChanged)
        
        
        // Date validator link
        dateTextField.addTarget(self, action: #selector(validateDate(textfield:)), for: .allEditingEvents)
        
        genderButtons(button: femaleButton)
        genderButtons(button: maleButton)

//        stackView.setCustomSpacing(60, after: phoneTextField)

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
    
    
    func setUpElements(){
        backView.layer.cornerRadius = 45
        dateTextField.text = ""
        
//        //Email icon
//        emailTextField.rightViewMode = UITextField.ViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        let image = UIImage(named: "mail")
//        imageView.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
//        imageView.image = image
//        emailTextField.rightView = imageView
//
//
//        // Password icon
//        passwordTextField.rightViewMode = UITextField.ViewMode.always
//        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        let image2 = UIImage(named:  "lock")
//        imageView2.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
//        imageView2.image = image2
//        passwordTextField.rightView = imageView2
//
//
//        // Phone icon
//
//        phoneTextField.rightViewMode = UITextField.ViewMode.always
//        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        let image3 = UIImage(named: "phone")
//        imageView3.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
//        imageView3.image = image3
//        phoneTextField.rightView = imageView3
//
//
//        // id icon
//
//        idTextField.rightViewMode = UITextField.ViewMode.always
//        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        let image4 = UIImage(named: "id")
//        imageView4.tintColor = (UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00))
//        imageView4.image = image4
//        idTextField.rightView = imageView4

        
        
        contButton.layer.cornerRadius = 45
        contButton.layer.backgroundColor = UIColor(red: 56/225, green: 97/225, blue: 93/225, alpha: 1).cgColor
        

//        eyeButton.bringSubviewToFront(eyeButton)
        
        
        passwordTextField.sendSubviewToBack(passwordTextField)
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)

        
        
        createDatePicker()
        
        //Hiding the error label just for now, convert it to a popup message later
//        errorLabel.alpha = 0
        
        // Styling up the textfields
        style(textfield: firstNameTextField)
        style(textfield: lastNameTextField)
        style(textfield: idTextField)
        style(textfield: emailTextField)
        style(textfield: phoneTextField)
        style(textfield: passwordTextField)
        style(textfield: dateTextField)
        
        
//
//        // Set up the back button
//        backButton.setImage(UIImage(systemName: "arrow.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .bold))
//        , for: .normal)
//        backButton.tintColor = UIColor.white

        
        
//            //styling the eye toggle button
//        let icon = UIImage(systemName: "eye.slash")
//        eyeButton.setImage(icon, for: .normal)
//        eyeButton.tintColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00)
//
//
        
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
    
    func style(textfield : UITextField){
        textfield.delegate = self
        style.normalStyle(TextField: textfield)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
    // Check the fields and validate that the data is correct. If everything is correct return nil, otherwise return the error message
    
    
    func validateFields() -> String? {
        
        
        // Don't forget to add an astericks on the required fields to prevent errors
        
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""

        
        {
            return "Please fill in all fields."
        }
        
        
        
        // Check if the password is secure, change it later
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure that your password ..."
        }
        
        
        
        
        return nil
    }
    
    // Change this method and replace it with a visible validator
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    
    
//
//    // Change this function to pop up message
//    func showError(_ message: String){
//
//        errorLabel.text = message
//        errorLabel.alpha = 1
//
//
//
//    }
    
    
    
    func transitionToHome(){
        
        // I have to check if the user is volunteer or hospital, but for now I will just try a single home
        
       let volunteerHomeViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.volunteerHomeViewController) as? HomeViewController
        
        view.window?.rootViewController = volunteerHomeViewController
        view.window?.makeKeyAndVisible()
    }
    

    
    @objc func turnTextFieldTextfieldToRed(textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    

    
    @IBAction func femaleSelected(_ sender: Any) {
        femaleSELECTED()
    }
    
    @IBAction func maleSelected(_ sender: Any) {
        maleSELECTED()
    }
    
    func maleSELECTED(){
        maleButton.isSelected = true
        maleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        femaleButton.isSelected = false
        femaleButton.backgroundColor = UIColor.white
        gender = "m"
        Constants.Globals.gender = "m"
    }
    func femaleSELECTED(){
        femaleButton.isSelected = true
        femaleButton.backgroundColor = UIColor.init(red: 182/255, green: 218/255, blue: 214/255, alpha: 1)
        
        maleButton.isSelected = false
        maleButton.backgroundColor = UIColor.white
        gender = "f"
        Constants.Globals.gender = "f"
    }
    
    func genderButtons(button : UIButton){
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        //        button.setTitleColor(.black, for: .normal)
        
    }
    
//    // Styling the textfields
//    @objc func styleTextFields(textfield: UITextField){
//
//        let bottomLine = CALayer()
//
//        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width , height: 2)
//
//        bottomLine.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
//
//        textfield.borderStyle = .none
//
//        textfield.layer.addSublayer(bottomLine)
//
//    }
    
    
    // Styling the textfields with pickers
//    @objc func styleTextFieldsWithPicker(textfield: UITextField){
//
//        let bottomLine = CALayer()
//
//        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 20, width: textfield.frame.width , height: 2)
//
//        bottomLine.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
//
//        textfield.borderStyle = .none
//
//        textfield.layer.addSublayer(bottomLine)
//
//    }
    
    
    
    
    
    
    // First name validation
    @objc func validateFirstName(textfield: UITextField){
        
        
        // Maximum Length
        if (textfield.text!.count >= 16) {
            firstNameError.text = "الاسم الأول يجب أن لا يتجاوز ١٦ حرفا"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
//            firstNamelabel.alpha = 1

        }
        // Required
        else if (textfield.text!.count == 0) {
            firstNameError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
//            firstNamelabel.alpha = 0


        }
        // Only letters
        else if (!isNameValid(textfield.text!)){
            firstNameError.text = "الاسم الأول يجب أن يتكون من أحرف فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
//            firstNamelabel.alpha = 1



        }
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
//            firstNameError.text="  "
            style(textfield: firstNameTextField)
//            firstNamelabel.alpha = 1

            Constants.Globals.firstName = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    
    
    
    
    // Last name validation
    @objc func validateLastName(textfield: UITextField){
        
        
        // Maximum Length
        if (textfield.text!.count >= 16) {
            lastNameError.text = "اسم العائلة يجب أن لا يتجاوز ١٦ حرفا"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
//            lastNameLabel.alpha = 1
        }
        
        // Required
        else if (textfield.text!.count == 0) {
            lastNameError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
//            lastNameLabel.alpha = 0

        }
        // ONly letters
        else if (!isNameValid(textfield.text!)){
            lastNameError.text = "اسم العائلة يجب أن يتكون من أحرف فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
//            lastNameLabel.alpha = 1

        }
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
//            lastNameError.text="  "
            style(textfield: lastNameTextField)
//            lastNameLabel.alpha = 1

            Constants.Globals.lastName = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        }
    }
        
        
        // ID validation
        @objc func validateID(textfield: UITextField){
            // Required
             if (textfield.text!.count == 0) {
                idError.text = "اجباري"
                // Turn the textfield to red
                turnTextFieldTextfieldToRed(textfield: idTextField)
//                idLabel.alpha = 0

            }
            // Only numbers
            else if (!isStringAnInt(textfield.text!)){
                idError.text = "رقم الأحوال المدنية/الإقامة يجب أن يتكون من أرقام فقط"
                // Turn the textfield to red
                turnTextFieldTextfieldToRed(textfield: idTextField)
//                idLabel.alpha = 1
            }
            
            // Maximum Length
           else if (textfield.text!.count >= 11) {
                idError.text = "رقم الأحوال المدنية/الإقامة يجب أن لا يتجاوز ١٠ أرقام"
                // Turn the textfield to red
                turnTextFieldTextfieldToRed(textfield: idTextField)
//            idLabel.alpha = 1

            }
            
          
            
            // Minimum Length
            else if (textfield.text!.count < 10) {
                idError.text = "رقم الأحوال المدنية/الإقامة يجب أن لا يقل عن ١٠ أرقام"
                // Turn the textfield to red
                turnTextFieldTextfieldToRed(textfield: idTextField)
//                idLabel.alpha = 1

            }
            
           
            
            // Everything is fine
            else {
                // White space so that the layout is not affected; however, trim it in the validation
//                idError.text="  "
                style(textfield: idTextField)
//                idLabel.alpha = 1

                Constants.Globals.id = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)


            }
        
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
    
    

    
    // Email validation
    @objc func validateEmail(textfield: UITextField){
                 
        
        // Required
        if (textfield.text!.count == 0) {
            emailError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
//            emailLabel.alpha = 0
        }
        // Email format
        else if (!isEmailValid(textfield.text!)){
            emailError.text = "البريد الالكتروني غير صالح"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
//            emailLabel.alpha = 1
        }
       /* else if (isEmailTaken()){
            emailError.text = "البريد الالكتروني مستخدم"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: emailTextField)
            emailLabel.alpha = 1

            
            
        }*/
        
        
   
        // Everything is fine
            
            
            else
            {
                isEmailTaken()
               /* print("HHHHHH" + String(Constants.Globals.isEmailUsed))
                if (Constants.Globals.isEmailUsed){
                    print ("i came here")
                    emailError.text = "البريد الالكتروني مستخدم"
                    // Turn the textfield to red
                    turnTextFieldTextfieldToRed(textfield: emailTextField)
                    emailLabel.alpha = 1

                    
                    
                }
                
            
            // email is not taken
            
            // White space so that the layout is not affected; however, trim it in the validation
                
                else{*/
//            emailError.text="  "
            style(textfield: emailTextField)
//            emailLabel.alpha = 1

                    Constants.Globals.email = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)}
            

        }
    

    @objc func isEmailTaken(){
         
            Auth.auth().fetchSignInMethods(forEmail: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), completion: {
               (providers, error) in

               if let error = error {
                   print ("email doesn't exist")
                   print(error.localizedDescription)
                   
               } else if let providers = providers {
                   print(providers)
                   
                   print("email exists")
                
                self.emailError.text = "البريد الالكتروني مستخدم"
                // Turn the textfield to red
                self.turnTextFieldTextfieldToRed(textfield: self.emailTextField)
//                self.emailLabel.alpha = 1
                
              }
            } )
        }
    

    
    
    // Date validation
    @objc func validateDate(textfield: UITextField){
        
    
        // Required
        if (textfield.text!.isEmpty) {
            dateError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: dateTextField)
//            dateLabel.alpha = 0
        }
       
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            dateError.text="  "
            style(textfield: dateTextField)
            let date = dateTextField.text!.prefix(10)
            Constants.Globals.birthdate = date.trimmingCharacters(in: .whitespacesAndNewlines)
//            dateLabel.alpha = 1


        }
    }
    
    
    
    
    // Email format validation
    func isEmailValid(_ email : String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: email)
    }
    
    
    
    
    
    // Phone validation
    @objc func validatePhone(textfield: UITextField){
        
        // Required
          if (textfield.text!.count == 0) {
            phoneNumberError.text = "اجباري"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
//            phoneLabel.alpha = 0

        }
        // Phone number should start with 05
         if ((!(textfield.text!.prefix(2) == "05")) && (!(textfield.text!.prefix(2) == "٠٥"))){
            
            phoneNumberError.text = "رقم الجوال يجب أن يبدأ ب ٠٥"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
//            phoneLabel.alpha = 1
            
        }
        // Only numbers
        else if (!isStringAnInt(textfield.text!)){
            phoneNumberError.text = "رقم الجوال يجب أن يتكون من أرقام فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
//            phoneLabel.alpha = 1

        }
       
        
        // Maximum Length
        else if (textfield.text!.count >= 11) {
            phoneNumberError.text = "رقم الجوال يجب أن لا يتجاوز ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
//            phoneLabel.alpha = 1

        }
        
        
        // Minimum Length
        else if (textfield.text!.count < 10) {
            phoneNumberError.text = "رقم الجوال يجب أن لا يقل عن ١٠ أرقام"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
//            phoneLabel.alpha = 1

        }
        
        
        
        
       
        
      
        
        
    
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            phoneNumberError.text="  "
            style(textfield: phoneTextField)
//            phoneLabel.alpha = 1

            Constants.Globals.phone = textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        }
    
}
    
    
    
    
    
    var passordCriteria = [0,0,0,0]
    var isPasswordStrong = false
    
    // Password validation
    @objc func validatePassword(textfield: UITextField){
        
        
        
        // Required
        if (textfield.text!.isEmpty) {

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
            containsNumsIcon.image = UIImage(systemName: "multiply.circle")
            containsNumsIcon.tintColor = UIColor.red
            containsSpecialIcon.tintColor = UIColor.red
            containsSpecialIcon.image = UIImage(systemName: "multiply.circle")
            charNumIcon.tintColor = UIColor.red



            
            
        }
         
         
         // Not Empty
        else if (!(textfield.text!.isEmpty)){
//            passwordLabel.alpha = 1

        
        
        
        

        
        
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
        
        
        else {            passwordStrength.progress = 0
            passwordError.text="الرقم السري ضعيف"

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
    
    
    
    
    
 
    
    
  
        

        
        
        
//    @IBAction func onEyeTapped(_ sender: Any) {
//
//
//    if (eyeButton.currentImage == UIImage(systemName: "eye.slash")){
//
//        eyeButton.setImage(UIImage(systemName: "eye")
//        , for: .normal)
//        passwordTextField.isSecureTextEntry = false}
//    else {
//        eyeButton.setImage(UIImage(systemName: "eye.slash")
//        , for: .normal)
//        passwordTextField.isSecureTextEntry = true
//
//
//    }
//    }
    
//     // Go tot the previous page
//    @IBAction func onBackTapped(_ sender: Any) {
//
//        _ = navigationController?.popViewController(animated: true)
//
//    }
    
    
   
    
    
    
    
    @IBAction func onPressedCont(_ sender: Any) {
    
        
        // Empty First name
        if (firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            firstNameError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: firstNameTextField)
        
        }
        
        // Empty last name
        if (lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            lastNameError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: lastNameTextField)
        
        }
        
        
        
        // Empty id
        if (idTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            idError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: idTextField)
        
        }
        
        // Empty email
        if (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            emailError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: emailTextField)
        
        }
        
        
        
        // Empty phone
        if (phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            phoneNumberError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: phoneTextField)
        
        }
        
        
        
        
        // Empty birthdate
        if (dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            dateError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: dateTextField)
        
        }
        
        
        
        // Empty password
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            passwordError.text = "اجباري"
            turnTextFieldTextfieldToRed(textfield: passwordTextField)
        
        }
        
        // Cont...
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var allValidations = firstNameError.text! + lastNameError.text! + idError.text! + emailError.text! + phoneNumberError.text!
        
        
         // Did not include the password here since I will check it down
          allValidations += dateError.text!
        
        
        // Just for testing
        let check = ((allValidations.trimmingCharacters(in: .whitespacesAndNewlines)))
        print (check)

        
        
        // If all the fields are filled and valid and the password is strong
         if (isPasswordStrong == true && check == ""){
            return true
        }
        
        // If all the fields are filled and valid but the password is weak/empty
        else if (isPasswordStrong == false && check == "")
        {
            
            
            return false
            
            
            
            
        }
        
        else {
            // Textfields are not valid or password is weak/empty
            print ("Weak/empty pass or some textfields are not valid")
                        
           

            return false
        }
        
    }
    
    
    
    
//    @IBAction func onPressedOk(_ sender: Any) {
//
//        self.popUpView.isHidden = true
//        self.blackBlurredView.isHidden = true
//
//    }
    
}
