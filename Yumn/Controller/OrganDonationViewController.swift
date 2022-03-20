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
    
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var seg2: UIView!
    var codeSegmented:CustomSegmentedControl? = nil
    @IBOutlet weak var segmentsView: UIView!
    
    @IBOutlet weak var roundView: UIView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
      //  roundView.layer.cornerRadius = 30
        
        super.viewDidLoad()
        
        
        
        //        print("\(String(describing: userLocation))")
        //        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0,width: seg2.frame.width,        height: 50.0))
        //        let control = BetterSegmentedControl.init(frame: CGRect(x: 0, y: 0, width:                    seg2.frame.width, height: 50), segments: , index: , options: )
        
        //        segmentedControl.selectedSegmentIndex = 2
        //        segmentedControl.removeBorder()
        //        segmentedControl.addUnderlineForSelectedSegment()
        //
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["مراكز التبرع","الإرشادات","الإحتياج"])
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
        if(index != 0){
        }
    }
    
}


