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

class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var seg2: UIView!
    var codeSegmented:CustomSegmentedControl? = nil
    
    var sortedHospitals:[Location]?
    var hController = HospitalsController()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMain.isHidden = true
        
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
        
        sortedHospitals = getHospitals()
        
        tableMain.dataSource = self
        tableMain.register(UINib(nibName: "HospitalCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalsCell")
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if(index==0){
            tableMain.isHidden = false
        }
        if(index != 0){
            tableMain.isHidden = true
        }
    }
    
}


extension BloodDonationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedHospitals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalsCell", for: indexPath) as! HospitalCellTableViewCell
        
        cell.hospitalName.text = sortedHospitals![indexPath.row].name
        cell.locationText.text = "\(sortedHospitals![indexPath.row].area) - \(sortedHospitals![indexPath.row].city)"
        
        let distance = String(format: "%.3f", sortedHospitals![indexPath.row].distance!)
        cell.distanceText.text = "يبعد: \(distance) كم"
        print ("Rawan cell")
        print (cell)
        return cell
    }
    
    
}

//
//struct BloodDonationViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
