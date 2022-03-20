//
//  BloodDonationViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 10/02/2022.
//

import UIKit
import SwiftUI
//import BetterSegmentedControl
import MapKit
import CoreLocation
import Firebase

class OrganDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    
    @IBOutlet weak var organBtn2: UIButton!
    @IBOutlet weak var arrow2: UIButton!
    @IBOutlet weak var organBtn1: UIButton!
    @IBOutlet weak var arrow1: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var organDonImage: UIImageView!
    @IBOutlet weak var organsStack1: UIStackView!
    @IBOutlet weak var organsStack2: UIStackView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
   // var location:CLLocation?
   // var userLocation:CLLocationCoordinate2D?
 //   @IBOutlet weak var seg2: UIView!
    
    
    var codeSegmented:CustomSegmentedControl? = nil
    @IBOutlet weak var segmentsView: UIView!
    
    @IBOutlet weak var roundView: UIView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        //Organ Donation Information
        label1.text = "يمكن التبرع بـ:"
        label2.text = "- جزء من الكبد"
        label3.text = "- إحدى الكليتين"
        arrow1.contentHorizontalAlignment = .left
        arrow2.contentHorizontalAlignment = .left
        organBtn1.contentHorizontalAlignment = .right
        organBtn2.contentHorizontalAlignment = .right
        organDonImage.superview?.bringSubviewToFront(organDonImage)
        stackView.superview?.bringSubviewToFront(stackView)
        organsStack1.clipsToBounds = true
        organsStack2.clipsToBounds = true
        organsStack1.isHidden = true
        organsStack2.isHidden = true
        organDonImage.isHidden = true
        stackView.isHidden = true
        

        
        super.viewDidLoad()
        
        
        
        //        print("\(String(describing: userLocation))")
        //        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0,width: seg2.frame.width,        height: 50.0))
        //        let control = BetterSegmentedControl.init(frame: CGRect(x: 0, y: 0, width:                    seg2.frame.width, height: 50), segments: , index: , options: )
        
        //        segmentedControl.selectedSegmentIndex = 2
        //        segmentedControl.removeBorder()
        //        segmentedControl.addUnderlineForSelectedSegment()
        //
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["نوع التبرع","الإرشادات","الإحتياج"])
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
            
            organDonImage.isHidden = true
            stackView.isHidden = true
            
            
        }
        else if(index == 1){
            
            organDonImage.isHidden = false
            stackView.isHidden = false
            
        }
        
        else {
            
            organDonImage.isHidden = true
            stackView.isHidden = true
            
        }
    }
    
    
    
    @IBAction func onPressedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    //Organ Donation Information
    @IBAction func onPressedArrow1(_ sender: Any) {
        
        organsStack1.isHidden = !organsStack1.isHidden
       
       if (organsStack1.isHidden == false){
        arrow1.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow1.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }

    }
    
    @IBAction func onPressedOrganBtn1(_ sender: Any) {
        
        organsStack1.isHidden = !organsStack1.isHidden
       
       if (organsStack1.isHidden == false){
        arrow1.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow1.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    
    
    @IBAction func onPressedOrganBtn2(_ sender: Any) {
        organsStack2.isHidden = !organsStack2.isHidden
       
       if (organsStack2.isHidden == false){
        arrow2.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow2.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    @IBAction func onPressedArrow2(_ sender: Any) {
        
        organsStack2.isHidden = !organsStack2.isHidden
       
       if (organsStack2.isHidden == false){
        arrow2.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow2.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    }

    

    
    



