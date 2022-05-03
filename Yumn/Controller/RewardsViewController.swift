//
//  RewardsViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 04/04/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class RewardsViewController: UIViewController {
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var roundview: UIView!
    
    @IBOutlet weak var sarLabel: UILabel!
    @IBOutlet weak var sarBox: UIView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    @IBOutlet weak var popupStack: UIStackView!
    @IBOutlet weak var getQRButton: UIButton!
    @IBOutlet weak var redeemLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var storesButton: UIButton!

    @IBOutlet weak var pointsBox: UIView!
    @IBOutlet weak var confetti: UIImageView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var popupMsg: UILabel!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("volunteer").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                
               
                    
                
                    
                    
                let vPoints:Int  = document.get("points") as! Int
                 

                self.points.text = self.convertEngToArabic(num: vPoints)
                
                self.sarLabel.text = "تكافئ " + String(self.convertEngToArabic(num: Int(floor(Double(vPoints/5))))) + " ريال سعودي"
                                                                        
            


                
            } else {
                print("Document does not exist")
            }
        }
        
        roundview.layer.cornerRadius = 35
        pointsBox.layer.cornerRadius = 30
        sarBox.layer.cornerRadius = 15
        storesButton.layer.cornerRadius = 25
        getQRButton.layer.cornerRadius = 25
        popupView.layer.cornerRadius = 35
        cancelBtn.layer.cornerRadius = 20
        confirmBtn.layer.cornerRadius = 20
        
        styleTextFields(textfield: amountTextfield)

        
        errorLabel.text = ""
        redeemLabel.text = ""
        
        
        amountTextfield.addTarget(self, action: #selector(validateAmount(textfield:)), for: .editingChanged)

        

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        pointsBox.superview?.bringSubviewToFront(pointsBox)
        points.superview?.bringSubviewToFront(points)
        sarBox.superview?.bringSubviewToFront(sarBox)
        sarLabel.superview?.bringSubviewToFront(sarLabel)
        popupStack.superview?.bringSubviewToFront(popupStack)
        popupView.superview?.bringSubviewToFront(popupView)
        
   

        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAllQRCodes" {
            let destinationVC = segue.destination as! AllQRCodesViewController
            
         
        }
    }
    
    @IBAction func generateQRCode(_ sender: Any) {
        
        
        if (amountTextfield.text?.isEmpty == true){
            
            errorLabel.text = "مطلوب"
            turnTextFieldTextfieldToRed(textfield: amountTextfield)
        }
        
        else if (errorLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
        
        popupView.isHidden = false

        blackBlurredView.isHidden = false
        
        popupTitle.text = "تأكيد استبدال النقاط"
        popupMsg.text = "هل أنت متأكد من رغبتك في استبدال نقاطك"
    }
        
        else {
            
            //Do nothing just show the error message
        }
        
        
    }
    
    
    
    func  convertEngToArabic(num: Int)-> String{
        
        let points=String(num)
        var arabicString=""
        
        for ch in points{
            
            switch ch {
                
            case "0":
                arabicString+="٠"
            case "9":
                arabicString+="٩"
            case "8":
                arabicString+="٨"
            case "7":
                arabicString+="٧"
            case "6":
                arabicString+="٦"
            case "5":
                arabicString+="٥"
            case "4":
                arabicString+="٤"
            case "3":
                arabicString+="٣"
            case "2":
                arabicString+="٢"
            case "1":
                arabicString+="١"
           
                
            default:
                arabicString="٠"
            }
        }
        return arabicString
    }

    
    
    
    @objc func turnTextFieldTextfieldToRed(textfield: UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width , height: 2)
        
        bottomLine.backgroundColor = UIColor.red.cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    @IBAction func onPressedQR(_ sender: Any) {
        
        print ("QR Btn clicked")
    }
    
    @IBAction func onPressedProfile(_ sender: Any) {
        
        print ("profile Btn clicked")

    }
    
    
    // Styling the textfields
    @objc func styleTextFields(textfield: UITextField){
        
        
        // It only worked this way in this page
        
        
        
           let bottomLine = CALayer()
           
           
          
              bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width  , height: 2)

               
           
           
           bottomLine.backgroundColor = UIColor(red:137/255, green: 191/255, blue: 186/255, alpha: 1.00).cgColor
           
           textfield.borderStyle = .none
           
           textfield.layer.addSublayer(bottomLine)
           
    
    }
    
    
    // Amount validation
    @objc func validateAmount(textfield: UITextField){
        
        let pointsRedeemed = ceil(((amountTextfield.text! as NSString).doubleValue))*5
        
        let v = (amountTextfield.text! as NSString).doubleValue
        
        let isLessThanZero = textfield.text! == "0" || textfield.text! == "٠" || v < 0

        // Required
         if (textfield.text!.count == 0) {
            errorLabel.text = "مطلوب"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: amountTextfield)
             redeemLabel.text = ""


        }
        
        else if (pointsRedeemed > (points.text! as NSString).doubleValue){
            
            if (pointsRedeemed > 10){
            errorLabel.text = "نقاطك لا تكفي لاستبدال " + convertEngToArabic(num: Int(pointsRedeemed)) + " نقطة"
            }
            else {
                errorLabel.text = "نقاطك لا تكفي لاستبدال " + convertEngToArabic(num: Int(pointsRedeemed)) + " نقاط"
            }
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: amountTextfield)
            redeemLabel.text = ""

            
        }
      
        
        // zero and negative  is not allowed
        
        else if (isLessThanZero){
            errorLabel.text = "المبلغ يجب أن يكون أكبر من صفر"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: amountTextfield)
            redeemLabel.text = ""
        }
        
        
        
        
       
        
        // Only numbers
        else if ((!isStringADouble(textfield.text!) && !isStringAnInt(textfield.text!))){
            errorLabel.text = "المبلغ يجب أن يتكون من أرقام فقط"
            // Turn the textfield to red
            turnTextFieldTextfieldToRed(textfield: amountTextfield)
            redeemLabel.text = ""

        }
        
       
        // Add a validation that it shouldn't exceed the points
        
       
        
        // Everything is fine
        else {
            // White space so that the layout is not affected; however, trim it in the validation
            
            if (pointsRedeemed > 10){
                redeemLabel.text = "سوف يتم استبدال " + convertEngToArabic(num: Int(pointsRedeemed)) + " نقطة"

            }
            else {
                redeemLabel.text = "سوف يتم استبدال " + convertEngToArabic(num: Int(pointsRedeemed)) + " نقاط"
            }
           

            errorLabel.text="  "
            styleTextFields(textfield: amountTextfield)

           


        }
    
}
    
    
    func isStringADouble(_ numberString: String) -> Bool {
        
     
       

        
        let idTest = NSPredicate(format: "SELF MATCHES %@", "^[٠-٩]+.[٠-٩]+$")
        
        let engTest = NSPredicate(format: "SELF MATCHES %@", "^[0-9]+.[0-9]+$")

        return idTest.evaluate(with: numberString) || engTest.evaluate(with: numberString)
        
    }
    
    // Validation for Arabic or English Numbers used for amount
    func isStringAnInt(_ id: String) -> Bool {
        
        let idTest = NSPredicate(format: "SELF MATCHES %@", "^[٠-٩]+$")
        
        return idTest.evaluate(with: id) || Int(id) != nil
        
    }

    
    
    @IBAction func onPressedCancel(_ sender: Any) {
        
        popupView.isHidden = true
        blackBlurredView.isHidden = true
    }
    
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func transitionToQr(){
        
        
        
       let QRViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.qrViewController) as? QRCodeViewController
        
        view.window?.rootViewController = QRViewController
        view.window?.makeKeyAndVisible()
        
        

    }

    
    func isArabicNum(num: String) -> Bool{
        
        let isArabicNumber = String(num.prefix(0)) == "٠" ||
        String(num.prefix(0)) == "١" ||
        String(num.prefix(0)) == "٢" ||
        String(num.prefix(0)) == "٣" ||
        String(num.prefix(0)) == "٤" ||
        String(num.prefix(0)) == "٥" ||
        String(num.prefix(0)) == "٦" ||
        String(num.prefix(0)) == "٧" ||
        String(num.prefix(0)) == "٨" ||
        String(num.prefix(0)) == "٩"

        
        return isArabicNumber
    }
    
    
    @IBAction func onPressedConfirm(_ sender: Any) {
        
        var amountNum = 0.0
        
        let isArabicNum = isArabicNum(num: amountTextfield.text!)
     
        
        if (isArabicNum){
          
         let amountEngString = convertArabicToEng(num: (amountTextfield.text! as NSString).doubleValue)
            
         amountNum = (amountEngString as NSString).doubleValue
        }
        
        else {
         amountNum = (amountTextfield.text! as NSString).doubleValue
        }
        
        
        let currentDateTime = Date()
        
        let dateString = formaDate(date: currentDateTime)
        
        
        let code = randomString(length: 10)
        
        Constants.Globals.currentQRID = code
        
        
        let db = Firestore.firestore()
        
        db.collection("code").document(code).setData([
        "amount": amountNum,
        "status": "valid",
        "createdAt": currentDateTime,
        "id": code,
        "dateCreated": dateString,
        "uid": Auth.auth().currentUser!.uid]){ error in
        
            if error != nil {
                
                print(error?.localizedDescription as Any)
                
            // Show error message or pop up message

                
                print ("error in saving the QR code data")
                
                
            }}
            
        let pointsRedeemed = Int(ceil(((amountTextfield.text! as NSString).doubleValue)*5))
        
 
            db.collection("volunteer").document(Auth.auth().currentUser!.uid).updateData([
                "points": (Int((points.text! as NSString).intValue) - pointsRedeemed),
                
                
                ]){ error in
            
                if error != nil {
                    
                    print(error?.localizedDescription as Any)
                    
                    print ("error in updating the points")
                    
                    
                }
            
            
           }
        
        
        Constants.Globals.newQR = true
    
            transitionToQr()
        
    
        

        
        
    }
    
    func formaDate(date: Date) -> String {
        
    let formatter = DateFormatter()
    
    formatter.dateFormat = "dd/MM/YYYY"
        
        return formatter.string(from: date)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        func  convertArabicToEng(num: Double)-> String{
            
            let points=String(num)
            var arabicString=""
            
            for ch in points{
                
                switch ch {
                    
                case "٠":
                    arabicString+="1"
                case "٩":
                    arabicString+="9"
                case "٨":
                    arabicString+="8"
                case "٧":
                    arabicString+="7"
                case "٦":
                    arabicString+="6"
                case "٥":
                    arabicString+="5"
                case "٤":
                    arabicString+="4"
                case "٣":
                    arabicString+="3"
                case "٢":
                    arabicString+="2"
                case "١":
                    arabicString+="1"
                case ".":
                    arabicString+="."
                    
                default:
                    arabicString="٠"
                }
            }
            return arabicString
        }

    
    


        

}
