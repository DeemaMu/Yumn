//
//  trial1.swift
//  Yumn
//
//  Created by Rawan Mohammed on 23/02/2022.
//

import Foundation
import UIKit

class Trial1: UIViewController {
    

    @IBOutlet weak var tableMain: UITableView!
    
    var hospitals:[Location] = [
        Location(name: "دلة", lat: 25.8777, long: 42.4444, city: "الرياض", area: "النخيل", distance: 20),
        Location(name: "الملك خالد", lat: 25.8778, long: 45.4444, city: "الرياض", area: "الدرعية", distance: 5),
        Location(name: "المملكة", lat: 26.8778, long: 46.4444, city: "الرياض", area: "الربيع", distance: 10)
    ]
    
    var sortedHospitals:[Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortedHospitals = hospitals.sorted(by: { (h0: Location, h1: Location) -> Bool in
            return h0.distance! < h1.distance!
        })
        
        tableMain.dataSource = self
        tableMain.register(UINib(nibName: "HospitalCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalsCell")
        
    }
    
}

extension Trial1: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalsCell", for: indexPath) as! HospitalCellTableViewCell
        
        cell.hospitalName.text = sortedHospitals![indexPath.row].name
        cell.locationText.text = "\(sortedHospitals![indexPath.row].area) - \(hospitals[indexPath.row].city)"
        cell.distanceText.text = "يبعد: \(String(describing: sortedHospitals![indexPath.row].distance))"
        
        return cell
    }
    
    
}
