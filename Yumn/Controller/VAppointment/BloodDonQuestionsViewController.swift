//
//  BloodDonQuestionsViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/03/2022.
//

import UIKit

class BloodDonQuestionsViewController: UIViewController {
    

    @IBOutlet weak var q1Btn: UIButton!
    
    @IBOutlet weak var q1Radio: UIButton!
    
    @IBOutlet weak var q2Btn: UIButton!
    
    @IBOutlet weak var q2Radio: UIButton!
    
    @IBOutlet weak var q3btn: UIButton!
    
    @IBOutlet weak var q3Radio: UIButton!
    
    @IBOutlet weak var q4Btn: UIButton!
    
    @IBOutlet weak var q4Radio: UIButton!
    
    @IBOutlet weak var q5Btn: UIButton!
    
    @IBOutlet weak var q5Radio: UIButton!
    
    @IBOutlet weak var q6Btn: UIButton!
    
    @IBOutlet weak var q6Radio: UIButton!
    
    @IBOutlet weak var q7Btn: UIButton!
    
    @IBOutlet weak var q7Radio: UIButton!
    
    @IBOutlet weak var contBtn: UIButton!
    
    @IBOutlet weak var popupStack: UIStackView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    var questions = [false, false,false, false, false, false, false]
    
    override func viewDidLoad() {
        
        contBtn.layer.cornerRadius = 25
        okBtn.layer.cornerRadius = 30
        popupView.layer.cornerRadius = 30
        q1Btn.contentHorizontalAlignment = .right
        q2Btn.contentHorizontalAlignment = .right
        q3btn.contentHorizontalAlignment = .right
        q4Btn.contentHorizontalAlignment = .right
        q5Btn.contentHorizontalAlignment = .right
        q6Btn.contentHorizontalAlignment = .right
        q6Btn.contentHorizontalAlignment = .right
        q7Btn.contentHorizontalAlignment = .right
       
        
        super.viewDidLoad()
        
        q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)


        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onPressedQ1(_ sender: Any) {
      
        
        questions[0] = !questions[0]
        print (questions[0])

        if (q1Radio.currentImage == UIImage(named: "fullRadio")){
            
            
                q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q1Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            

        }
    
    }
    
    @IBAction func onPressedQ1Radio(_ sender: Any) {
      
        questions[0] = !questions[0]
        print (questions[0])
        if (q1Radio.currentImage == UIImage(named: "fullRadio")){
            
            
                q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q1Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            

        }
    }
    
    
    
    
    @IBAction func onPressedCont(_ sender: Any) {
    }
    
 
    @IBAction func onPressedOk(_ sender: Any) {
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
