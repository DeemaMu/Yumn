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
   
    @IBOutlet weak var pointsBox: UIView!
    
    override func viewDidLoad() {
        
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("volunteer").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
               
                    
                
                    
                    
                let vPoints:Int  = document.get("points") as! Int
                 

                self.points.text = self.convertEngToArabic(num: vPoints)


                
            } else {
                print("Document does not exist")
            }
        }
        
        roundview.layer.cornerRadius = 35
        pointsBox.layer.cornerRadius = 30

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)


        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
