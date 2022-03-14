//
//  BloodDonationViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 10/02/2022.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation
import Firebase
import SnapKit
import MaterialDesignWidgets


class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    
    var location:CLLocation?
    var userLocation:CLLocationCoordinate2D?
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var seg2: UIView!
    var codeSegmented:CustomSegmentedControl? = nil
    
    var sortedHospitals:[Location]?
    var hController = HospitalsController()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMain.isHidden = true
        
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["مراكز التبرع","الإرشادات","الإحتياج"])
        codeSegmented!.backgroundColor = .clear
//        segmentsView.addSubview(codeSegmented!)
        
        
        codeSegmented?.delegate = self
        
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.removeBorder()
        segmentedControl.addUnderlineForSelectedSegment()
        
        sortedHospitals = getHospitals()
        
        tableMain.dataSource = self
        tableMain.register(UINib(nibName: "HospitalCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalsCell")
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        
        addSegments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func addSegments(){
        
        let segments = ["مراكز التبرع","الإرشادات","الإحتياج"]
        
        let sgLine = MaterialSegmentedControlR(selectorStyle: .line, fgColor: .gray, selectedFgColor: UIColor.init(named: "mainLight")!, selectorColor: UIColor.init(named: "mainLight")!, bgColor: .white)
        
//        sgLine.viewWidth =
        
        guard let customFont = UIFont(name: "Tajawal", size: 15) else {
            fatalError("""
                             Failed to load the "Tajawal" font.
                             Make sure the font file is included in the project and the font name is spelled correctly.
                             """
            )
        }
        
        segmentsView.addSubview(sgLine)
        
        for i in 0..<3 {
            sgLine.appendTextSegment(text: segments[i], textColor: .gray, font: customFont, rippleColor: #colorLiteral(red: 0.4438726306, green: 0.7051679492, blue: 0.6503567696, alpha: 0.5) , cornerRadius: CGFloat(0))
           
        }
        
        sgLine.frame = CGRect(x: 2, y: 2, width: segmentsView.frame.width - 4 , height: segmentsView.frame.height - 4)
                
        sgLine.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
        
        segmentsView.addSubview(sgLine)
        segmentsView.semanticContentAttribute = .forceRightToLeft
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
    
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
           switch sender.selectedSegmentIndex {
           case 0:
               tableMain.isHidden = false
           case 1:
               tableMain.isHidden = true
           default:
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
        
        return cell
    }
    
    
}


extension BloodDonationViewController{
   
        
        @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
            segmentedControl.changeUnderlinePosition()
            print("index changed")
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            segmentedControl.setupSegment()
        }
        
        
    }

    extension UISegmentedControl {
        
        func removeBorder(){
            
            guard let customFont = UIFont(name: "Tajawal", size: 18) else {
                fatalError("""
                                 Failed to load the "Tajawal" font.
                                 Make sure the font file is included in the project and the font name is spelled correctly.
                                 """
                )
            }
            
            self.tintColor = UIColor.clear
            self.backgroundColor = UIColor.clear
            self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
            self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray,  NSAttributedString.Key.font: customFont], for: .normal)
            if #available(iOS 13.0, *) {
                self.selectedSegmentTintColor = UIColor.clear
            }
            
            
            setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.white), for: .normal, barMetrics: .default)
            setBackgroundImage(imageWithColor(color: UIColor.white), for: .selected, barMetrics: .default)
            tintColor = UIColor.init(named: "mainLight")
            
            setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            //       setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font : customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
        }
        
        
        private func imageWithColor(color: UIColor) -> UIImage {
            let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor);
            context!.fill(rect);
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image!
        }
        
        func setupSegment() {
    //        self.removeBorder()
    //        let segmentUnderlineWidth: CGFloat = self.bounds.width
    //        let segmentUnderlineHeight: CGFloat = 4.0
    //        let segmentUnderlineXPosition = self.bounds.minX
    //        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
    //        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
    //        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
    //        segmentUnderline.backgroundColor = UIColor.clear
            self.removeBorder()
    //        self.addSubview(segmentUnderline)
            self.addUnderlineForSelectedSegment()
        }
        
        func addUnderlineForSelectedSegment(){
            
            let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
            let underlineHeight: CGFloat = 4.0
            let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
            let underLineYPosition = self.bounds.size.height - 1.0
            let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
            let underline = UIView(frame: underlineFrame)
            underline.backgroundColor = UIColor.init(named: "mainLight")
            underline.tag = 1
            self.addSubview(underline)
            
            
        }
        
        func changeUnderlinePosition(){
            guard let underline = self.viewWithTag(1) else {return}
            let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
            underline.frame.origin.x = underlineFinalXPosition
            
        }

}

//
//struct BloodDonationViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
