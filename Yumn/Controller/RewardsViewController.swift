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
    
    @IBOutlet weak var getQRButton: UIButton!
    @IBOutlet weak var redeemLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var storesButton: UIButton!
    @IBOutlet weak var qrButton: UIBarButtonItem!
    @IBOutlet weak var redCircle: UIImageView!
    @IBOutlet weak var pointsBox: UIView!
    @IBOutlet weak var confetti: UIImageView!
    
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
        
        redCircle.isHidden = true
        



        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPressedQr(_ sender: Any) {
        
        redCircle.isHidden = true
        
        
    }
    
    @IBAction func generateQRCode(_ sender: Any) {
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
        
        let pointsRedeemed = ceil(((amountTextfield.text! as NSString).doubleValue)*5)
        
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
        else if (!isStringAnInt(textfield.text!)){
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
    
    
    // Vlidation for Arabic or English Numbers used for ID and Phone
    func isStringAnInt(_ id: String) -> Bool {
        
        let idTest = NSPredicate(format: "SELF MATCHES %@", "^[٠-٩]+$")
        
        return idTest.evaluate(with: id) || Int(id) != nil
        
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
