//
//  AllQRCodesViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 18/04/2022.
//

import UIKit
import Firebase


class AllQRCodesViewController: UIViewController, CustomSegmentedControlDelegate {

    @IBOutlet weak var validQRCodesTableView: UITableView!
    
    
    @IBOutlet weak var whiteView: UIView!
    
    var codeSegmented:CustomSegmentedControl2Btns? = nil

    @IBOutlet weak var segmentsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        whiteView.layer.cornerRadius = 35
        
        
        
        codeSegmented = CustomSegmentedControl2Btns(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["الرموز الصالحة","الرموز المستخدمة"])
        codeSegmented!.backgroundColor = .clear
        //        codeSegmented.delegate?.change(to: 2)
        segmentsView.addSubview(codeSegmented!)
        codeSegmented?.delegate = self
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        

    }
    
    
    func change(to index: Int) {
            print("segmentedControl index changed to \(index)")
            if(index==0){
                
                
                
            }
             else {
                 
                 
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
}
