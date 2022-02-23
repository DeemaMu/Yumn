//
//  BloodDonationViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 10/02/2022.
//

import UIKit
import SwiftUI
import BetterSegmentedControl
import MapKit
import CoreLocation
import Firebase

class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var seg2: UIView!
    
    var sortedHospitals:[Location]?
    var hController = HospitalsController()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

//        print("\(String(describing: userLocation))")
//        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0,width: seg2.frame.width,        height: 50.0))
//        let control = BetterSegmentedControl.init(frame: CGRect(x: 0, y: 0, width:                    seg2.frame.width, height: 50), segments: , index: , options: )
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["مراكز التبرع","الإرشادات","الإحتياج"])
        codeSegmented.backgroundColor = .clear
//        codeSegmented.delegate?.change(to: 2)
        segmentsView.addSubview(codeSegmented)
        
        // trial for retrieveing data
        //
//        hController.userLocation = self.userLocation
//        sortedHospitals = hController.getHospitals()
        sortedHospitals = getHospitals()
        tableMain.dataSource = self
        tableMain.register(UINib(nibName: "HospitalCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalsCell")
            

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
                
    }
    
    func change(to index: Int) {
        if(index==0){
            
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
        
        return cell
    }
    
    
}

//
//struct BloodDonationViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
