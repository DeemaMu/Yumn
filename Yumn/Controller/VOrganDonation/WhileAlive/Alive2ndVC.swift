//
//  AfterDeathODFirstController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class Alive2ndVC: UIViewController {
    
    @IBOutlet weak var stepper: UIImageView!
    
    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var blackBlurredView: UIView!

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupMsg: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
//    @IBOutlet weak var selectionHolder: UIView!
    
    @IBOutlet weak var firstSection: UIView!
    @IBOutlet weak var secondSection: UIView!
    
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
    
    @IBOutlet weak var contBtn: UIButton!

    @IBOutlet weak var regulationsStack: UIStackView!
    
    var questions = [false, false,false, false, false, false]
    
    override func viewDidLoad() {
        
        print("\(Constants.selected.selectedOrgan.organ)")
        super.viewDidLoad()
        viewWillAppear(true)
        
        popupView.superview?.bringSubviewToFront(popupView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        if(Constants.selected.selectedOrgan.organ == "kidney"){
            self.title = "التبرع بكلية"
        }
        if(Constants.selected.selectedOrgan.organ == "liver"){
            self.title = "التبرع بجزء من الكبد"
        }
        
//        contBtn.layer.cornerRadius = 25
        okBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
        
//        let childView = UIHostingController(rootView: AfterDeathOrganSelection(controller: self))
//        addChild(childView)
//        childView.view.frame = selectionHolder.bounds
//        selectionHolder.addSubview(childView.view)
        
        
        q1Btn.contentHorizontalAlignment = .right
        q2Btn.contentHorizontalAlignment = .right
        q3btn.contentHorizontalAlignment = .right
        q4Btn.contentHorizontalAlignment = .right
        q5Btn.contentHorizontalAlignment = .right
        q6Btn.contentHorizontalAlignment = .right
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
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
        let nav = self.navigationController?.navigationBar
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
    
    func showFirstSection(){
        
    }
    
    func showSecondSection(){
        
    }
    
    func showThirdSection(){
        
    }
    
    func showFourthSection(){
        
    }
    
    
    @IBAction func onPressedQ1(_ sender: Any) {
        
        questions[0] = !questions[0]
        print (questions)
        
        if (q1Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q1Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
        
    }
    
    @IBAction func onPressedQ1Radio(_ sender: Any) {
        
        questions[0] = !questions[0]
        print (questions)
        
        if (q1Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q1Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedQ2(_ sender: Any) {
        
        questions[1] = !questions[1]
        print (questions)
        
        if (q2Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q2Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q2Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
        
        
    }
    
    
    @IBAction func onPressedRadio2(_ sender: Any) {
        questions[1] = !questions[1]
        print (questions)
        
        if (q2Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q2Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q2Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedRadio3(_ sender: Any) {
        questions[2] = !questions[2]
        print (questions)
        
        if (q3Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q3Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q3Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    
    @IBAction func onPressedQ3(_ sender: Any) {
        
        questions[2] = !questions[2]
        print (questions)
        
        if (q3Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q3Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q3Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedRadio4(_ sender: Any) {
        
        questions[3] = !questions[3]
        print (questions)
        
        if (q4Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q4Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q4Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPrssedQ4(_ sender: Any) {
        questions[3] = !questions[3]
        print (questions)
        
        if (q4Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q4Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q4Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedQ5(_ sender: Any) {
        
        questions[4] = !questions[4]
        print (questions)
        
        if (q5Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q5Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q5Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedRadio5(_ sender: Any) {
        questions[4] = !questions[4]
        print (questions)
        
        if (q5Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q5Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q5Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    @IBAction func onPressedQ6(_ sender: Any) {
        
        questions[5] = !questions[5]
        print (questions)
        
        if (q6Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q6Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q6Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedCont(_ sender: Any) {
        
        let isValidDonor = questions[0]&&questions[1]&&questions[2]&&questions[3]&&questions[4]
        
        if (!isValidDonor){
            
            popupTitle.text = "مقدرين حبك للمساعدة"
//            popupMsg.text = """
//للأسف، أنت غير مؤهل للتبرع
//            بالأعضاء بعد الوفاة
//"""
            popupView.isHidden = false
            blackBlurredView.isHidden = false
        }
        
        else{
            
            performSegue(withIdentifier: "goToOrganSelection", sender: nil)
            
            //Go to next page
        }
    }
    
    func onPressedCont(valid: Bool) {
        
        if (!valid){
            
            popupTitle.text = "مقدرين حبك للمساعدة"
//            popupMsg.text = """
//للأسف، أنت غير مؤهل للتبرع
//            بالأعضاء بعد الوفاة
//"""
            popupView.isHidden = false
            blackBlurredView.isHidden = false
        }
        
        else{
            
            performSegue(withIdentifier: "goToOrganSelection", sender: nil)
            
            //Go to next page
        }
    }
    
}
