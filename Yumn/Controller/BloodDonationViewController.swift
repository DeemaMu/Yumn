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

class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    
    @IBOutlet weak var hospitalsList: UITableView!
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var seg2: UIView!
    
    
    var hospitals:[Location] = [
        Location(name: "دلة", lat: 25.8777, long: 42.4444, city: "الرياض", area: "النخيل"),
        Location(name: "الملك خالد", lat: 25.8778, long: 45.4444, city: "الرياض", area: "الدرعية"),
        Location(name: "المملكة", lat: 26.8778, long: 46.4444, city: "الرياض", area: "الربيع")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("\(String(describing: userLocation))")
//        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0,width: seg2.frame.width,        height: 50.0))
//        let control = BetterSegmentedControl.init(frame: CGRect(x: 0, y: 0, width:                    seg2.frame.width, height: 50), segments: , index: , options: )
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["مراكز التبرع","الإرشادات","الإحتياج"])
        codeSegmented.backgroundColor = .clear
//        codeSegmented.delegate?.change(to: 2)
        segmentsView.addSubview(codeSegmented)
        
        hospitals[0].distance = calculateDistance( lat: hospitals[0].lat, long: hospitals[0].long)
        hospitals[1].distance = calculateDistance( lat: hospitals[1].lat, long: hospitals[1].long)
        hospitals[2].distance = calculateDistance( lat: hospitals[2].lat, long: hospitals[2].long)
        
    
        let sortedHospitals = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
            return h0.distance! < h1.distance!
        })
        
        hospitals = sortedHospitals
        
        hospitalsList.dataSource = self
//        hospitalsList.register(UINib(nibName: "HospitalCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HospitalsCell")
        
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
//        hospitalsList.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func change(to index: Int) {
        
    }
    
    func getAllLocations(){
        
    }
    
    
    func calculateDistance(lat: Double, long: Double ) -> Double {
        let currentLocation = CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        let DestinationLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: DestinationLocation) / 1000
        return distance
        
    }
    

}


extension BloodDonationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = "10"
//        cell.hospitalName.text = hospitals[indexPath.row].name
//        cell.locationText.text = "\(hospitals[indexPath.row].area) - \(hospitals[indexPath.row].city)"
//        cell.distanceText.text = "يبعد: \(String(describing: hospitals[indexPath.row].distance))"
        return cell
    }
    
    
}

//
//struct BloodDonationViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
