//
//  OrganDonInfoViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 17/03/2022.
//
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



class OrganDonInfoViewController: UIViewController{
    
    @IBOutlet weak var organLabel2: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var typeStack: UIStackView!
    
   
    @IBOutlet weak var bloodArrow: UIButton!
    
    @IBOutlet weak var typeText: UILabel!
  
    
   // @IBOutlet weak var stackView: UIStackView!
    
   
    @IBOutlet weak var donBtn: UIButton!
    
   
  
    
    @IBOutlet weak var donInfo: UIStackView!
    
  
    
    @IBOutlet weak var organLabel: UILabel!
    
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var typeArrow: UIButton!
    
    
    
    override func viewDidLoad() {
        
        //organLabel.isHidden = true
       // organLabel2.isHidden = true
       // titleLabel.isHidden = true
        
      
            

      //  stackView.setCustomSpacing(20, after: stack1)
        
       // donInfo.isHidden = true
     
        typeArrow.contentHorizontalAlignment = .left

        bloodArrow.contentHorizontalAlignment = .left
        donBtn.contentHorizontalAlignment = .right
        typeBtn.contentHorizontalAlignment = .right
        
        super.viewDidLoad()
        
        organLabel.clipsToBounds = true
     
        
        organLabel.text = "جزء من الكبد"
        organLabel2.text = "إحدى الكليتين"
        titleLabel.text = "يمكن التبرع بـ:"

       // donInfo.isHidden = true
        typeText.isHidden = true

        // Do any additional setup after loading the view.
    }
    
 @IBAction func onPressedDonBtn(_ sender: Any) {
    
        
        organLabel.isHidden = !organLabel.isHidden
        titleLabel.isHidden = !titleLabel.isHidden
        organLabel2.isHidden = !organLabel2.isHidden
       
       if (organLabel.isHidden == false){
        bloodArrow.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           bloodArrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)

           
       }
    }
    
  

        
    @IBAction func onPresssedTypeBtn(_ sender: Any) {
        donInfo.isHidden = !donInfo.isHidden
        
        if (donInfo.isHidden == false){
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



