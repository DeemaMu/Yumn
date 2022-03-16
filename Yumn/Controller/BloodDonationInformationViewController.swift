//
//  BloodDonationInformationViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 16/03/2022.
//

import UIKit
import Foundation
import Firebase
import SwiftUI



class BloodDonationInformationViewController: UIViewController{
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var typeStack: UIStackView!
    
    @IBOutlet weak var bloodArrow: UIButton!
    
    @IBOutlet weak var typeText: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
   
    @IBOutlet weak var donBtn: UIButton!
    
    @IBOutlet weak var donInfo: UILabel!
    
  
  
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var typeArrow: UIButton!
    
    
    
    override func viewDidLoad() {
        
        let db = Firestore.firestore()

        let infoRef = db.collection("information").document("blood")
        
            
        infoRef.getDocument { (document, error) in
            if let document = document, document.exists {

                    let info = document.get("information") as! String
    

                    
                    print (info)
                } else {
                    print("error")
                }

                
           
            }

       // stackView.setCustomSpacing(20, after: btn)
        
        typeStack.isHidden = true
     
        typeArrow.contentHorizontalAlignment = .left

        bloodArrow.contentHorizontalAlignment = .left
        donBtn.contentHorizontalAlignment = .right
        typeBtn.contentHorizontalAlignment = .right
        
        super.viewDidLoad()
        
        donInfo.clipsToBounds = true
        donInfo.text = "هو إجراء طبي تطوعي يتم بنقل الدم أو أحد مركباته من شخص سليم معافى إلى شخص مريض يحتاج للدم. وهذا الإجراء يحتاج إليه الملايين من الناس كل عام. فيستخدم أثناء الجراحة أو الحوادث أو بعض الأمراض التي تتطلب نقل بعض مكونات الدم."
        
        typeText.text = "hi hi hi hi "

        donInfo.isHidden = true
        typeText.isHidden = true

        // Do any additional setup after loading the view.
    }
    
   @IBAction func onPressedDonBtn(_ sender: Any) {
    
        
        donInfo.isHidden = !donInfo.isHidden
       
       if (donInfo.isHidden == false){
        bloodArrow.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           bloodArrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)

           
       }
    }
    
  

        
    @IBAction func onPresssedTypeBtn(_ sender: Any) {
        typeStack.isHidden = !typeStack.isHidden
        
        if (typeStack.isHidden == false){
         typeArrow.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        
        else{
            typeArrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)

            
        }

    }
    
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


