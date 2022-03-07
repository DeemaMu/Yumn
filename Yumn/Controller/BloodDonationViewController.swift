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
import Charts

class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate, ChartViewDelegate {
    
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var seg2: UIView!
    var codeSegmented:CustomSegmentedControl? = nil
    
    var sortedHospitals:[Location]?
    var hController = HospitalsController()
    
    let db = Firestore.firestore()
    
    
    
    // By Modhi
    var pieChart = PieChartView()
    let user = Auth.auth().currentUser
    @IBOutlet weak var viewPie: UIView!
    @IBOutlet weak var viewPieWhole: UIView!
    @IBOutlet weak var cityOfUser: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMain.isHidden = true
        // By Modhi
        pieChart.delegate = self
        viewPieWhole.isHidden = false
        viewPie.isHidden = false
        pieChart.isHidden = false
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
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // By Modhi
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

        guard let customFont2 = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        
        
        // updated
        cityOfUser.font = UIFontMetrics.default.scaledFont(for: customFont2)
        cityOfUser.adjustsFontForContentSizeCategory = true
        cityOfUser.font = cityOfUser.font.withSize(24)
        
       
        // for rounded top corners (view)
        if #available(iOS 11.0, *) {
                self.viewPie.clipsToBounds = true
            viewPie.layer.cornerRadius = 35
            viewPie.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        
        
        //loadingIndicator(loadingTag: 1)
        
        setUpChart() // in extension
        
        getTotalBloodShortage(completion: { totalBloodDict in
            if let TBS = totalBloodDict {
                //use the return value
                self.populateChart(TBS: TBS)
             } else {
                 //handle nil response
                 print("couldn't build pie chart")
             }
               
            })
        
    }
    
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if(index==0){
            tableMain.isHidden = false
        }
        if(index != 0){
            tableMain.isHidden = true
        }
        
        // By Modhi
        if(index==2){
            viewPieWhole.isHidden = false
            viewPie.isHidden = false
            pieChart.isHidden = false
        }
        if(index != 2){
            viewPieWhole.isHidden = true
            viewPie.isHidden = true
            pieChart.isHidden = true
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
