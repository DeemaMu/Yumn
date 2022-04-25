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
import MaterialDesignWidgets
import Charts



class VolunteerBloodAppointmensViewController: UIViewController, CustomSegmentedControlDelegate {
    
    
  
    
    func change(to index: Int) {
        
    }
 
    @IBOutlet weak var tableMainForCurrentBldApp: UITableView! // current app table
//@IBOutlet weak var BldAppLabel: UILabel!
@IBOutlet weak var deleteAppPopUp: UIView!
@IBOutlet weak var bldAppHospitalName: UILabel!
@IBOutlet weak var bldAppDate: UILabel!

@IBOutlet weak var bldAppTime: UILabel!
@IBOutlet weak var deleteAppLabel: UILabel!
@IBOutlet weak var questionLabel: UILabel!
@IBOutlet weak var placeLabel: UILabel!
@IBOutlet weak var dateLabel: UILabel!
@IBOutlet weak var timeLabel: UILabel!
    
@IBOutlet weak var deleteAppBtn: UIButton!
    
    
    
    @IBOutlet weak var segmentsView: UIView!
    
    // by modhi
    @IBOutlet weak var oldAppTable: UITableView!
    
    @IBOutlet weak var noAppLabel: UILabel!
    @IBOutlet weak var mapsAvailablePopUp: UIView!
    
    @IBOutlet weak var mapPopUpBtn: UIButton!
    @IBOutlet weak var mapPopUpMsg: UILabel!
    @IBOutlet weak var blurredView: UIView!
    
    
    var storedOldBldApp: [bloodAppointment] = []
    var storedCurrentBldApp: [bloodAppointment] = []
    var clickedCellIndex: Int = -1

    
    // By Modhi
    let user = Auth.auth().currentUser

    
    var codeSegmented:CustomSegmentedControl? = nil
    
//    var sortedHospitals:[Location]?
 //   var hController = HospitalsController()
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 

        
        oldAppTable.isHidden = true
        tableMainForCurrentBldApp.isHidden = false
        
        
        deleteAppPopUp.layer.cornerRadius = 17
        deleteAppBtn.layer.cornerRadius = 12
        deleteAppBtn.layer.masksToBounds = true
        
        mapPopUpBtn.layer.cornerRadius = 9
        mapPopUpBtn.layer.masksToBounds = true
        
        mapsAvailablePopUp.layer.cornerRadius = 17
       // mapsAvailablePopUp.layer.cornerRadius = 12
        mapsAvailablePopUp.layer.masksToBounds = true
        
        
        tableMainForCurrentBldApp.dataSource = self
        oldAppTable.dataSource = self

        // current blood app table
        tableMainForCurrentBldApp.register(UINib(nibName: "currentBldAppCell", bundle: nil), forCellReuseIdentifier: "currentBACell")
        
        
        oldAppTable.register(UINib(nibName: "oldBloodAppTableViewCell", bundle: nil), forCellReuseIdentifier: "oldBloodACell")

        
        // on index change
        getCurrentAppointments(userID:user!.uid)
        
         getOldAppointments(userID:user!.uid)
        
        
        
        
        
        
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["المواعيد السابقة","المواعيد الحالية"])
        codeSegmented!.backgroundColor = .clear
        //        segmentsView.addSubview(codeSegmented!)
        
        
        codeSegmented?.delegate = self
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.removeBorder()
        segmentedControl.addUnderlineForSelectedSegment()
        
        //sortedHospitals = getHospitals()
        
       // tableMain.dataSource = self
       // tableMain.register(UINib(nibName: "HospitalCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalsCell")
        
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        guard let customFont2 = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                     Failed to load the "CustomFont-Light" font.
                     Make sure the font file is included in the project and the font name is spelled correctly.
                     """
            )
        }
        mapPopUpMsg.font = UIFontMetrics.default.scaledFont(for: customFont2)
        mapPopUpMsg.adjustsFontForContentSizeCategory = true
        mapPopUpMsg.font = mapPopUpMsg.font.withSize(17)
        
    }
    
    
    func getCurrentAppointments(userID : String)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        print("current date is \(currentDate)")
                

        db.collection("volunteer").document(userID).collection("bloodAppointments").whereField("date", isGreaterThanOrEqualTo: currentDate).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noAppLabel.isHidden = true
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    let hospitalID:String = doc["hospitalID"] as! String
                    let latitude:Double = doc["latitude"] as! Double
                    let longitude:Double = doc["longitude"] as! Double
                    let name: String = doc["hospitalName"] as! String
                    let city: String = doc["city"] as! String
                    let area: String = doc["area"] as! String
                    let date: String = doc["date"] as! String
                    let time: String = doc["time"] as! String
                    let appID: String = doc["appID"] as! String
                    
                    self.storedCurrentBldApp.append(bloodAppointment(hospitalID:hospitalID, name: name, lat: latitude, long: longitude, city: city, area: area, date: date, time: time, appID: appID))
                }

                DispatchQueue.main.async {
                    self.tableMainForCurrentBldApp.reloadData()
                }
                
            }// end if stm
                
                else {
                    
                    self.noAppLabel.text = "لا يوجد مواعيد حالية"
                    self.noAppLabel.isHidden = false
                    print("no available current appointments")
                }
                
            } // end else
        }
        

    } // end of getApp func
    
    
    
    func getOldAppointments(userID : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'+3"
       // dateFormatter.dateFormat = "MMMM d, yyyy HH:mm:sss"
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        print("current date is \(currentDate)")
                

        db.collection("volunteer").document(userID).collection("bloodAppointments").whereField("date", isLessThan: currentDate).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noAppLabel.isHidden = true
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    let hospitalID:String = doc["hospitalID"] as! String
                    let latitude:Double = doc["latitude"] as! Double
                    let longitude:Double = doc["longitude"] as! Double
                    let name: String = doc["hospitalName"] as! String
                    let city: String = doc["city"] as! String
                    let area: String = doc["area"] as! String
                    let date: String = doc["date"] as! String
                    let time: String = doc["time"] as! String
                    let appID: String = doc["appID"] as! String
                    
                    self.storedOldBldApp.append(bloodAppointment(hospitalID:hospitalID, name: name, lat: latitude, long: longitude, city: city, area: area, date: date, time: time, appID: appID))
                }

                DispatchQueue.main.async {
                    self.oldAppTable.reloadData()
                }
                
            }// end if stm
                
                else {
                    
                    self.noAppLabel.text = "لا يوجد مواعيد سابقة"
                    self.noAppLabel.isHidden = false
                    print("no available old appointments")
                }
                
            } // end else
        }
        

    }// end func
    
    @IBAction func cancelingAppDelete(_ sender: Any) {
        
        blurredView.isHidden = true
        deleteAppPopUp.isHidden = true
        
    }
    
    // delete from hospital too
    @IBAction func deletingAppBtn(_ sender: Any) {
        
        
        let appointmentID = storedCurrentBldApp[clickedCellIndex].appID
    
        // make it current user
        // delete the app in firestore
         db.collection("volunteer").document("iDhMoT6PacOwKgKLi8ILK98UrB03").collection("bloodAppointments").document(appointmentID).delete() { err in
            if let err = err {
                print("Error removing appointment document: \(err)")
                
                components().showToast(message: "حدثت مشكلة أثناء حذف الموعد، الرجاء المحاولة مرة أخرى", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn")!, viewC: self)
            } else {
                // remove it from array so that the cell is removed
                self.storedCurrentBldApp.remove(at: self.clickedCellIndex)
                self.tableMainForCurrentBldApp.reloadData()
                // show flushbar
                print("Appointment document successfully removed!")
                self.blurredView.isHidden = true
                self.deleteAppPopUp.isHidden = true
                
                components().showToast(message: "تم حذف الموعد بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
            }
        }
        
    }
    
    
    
    @IBAction func okayMapBtn(_ sender: Any) {
        self.blurredView.isHidden = true
        self.mapsAvailablePopUp.isHidden = true
    }
    
    
    
    func addSegments(){
        
        let segments = ["المواعيد السابقة","المواعيد الحالية"]
        
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
        
        for i in 0..<2 {
            sgLine.appendTextSegment(text: segments[i], textColor: .gray, font: customFont, rippleColor: #colorLiteral(red: 0.4438726306, green: 0.7051679492, blue: 0.6503567696, alpha: 0.5) , cornerRadius: CGFloat(0))
            
        }
        
        sgLine.frame = CGRect(x: 2, y: 2, width: segmentsView.frame.width - 4 , height: segmentsView.frame.height - 4)
        
        sgLine.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
        
        segmentsView.addSubview(sgLine)
        segmentsView.semanticContentAttribute = .forceRightToLeft
    }
    
    
    
    // update it
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
        switch sender.selectedSegmentIndex {
        case 0:
           
            tableMainForCurrentBldApp.isHidden = true
            oldAppTable.isHidden = false
         
            break
        case 1:
   
            tableMainForCurrentBldApp.isHidden = false
            oldAppTable.isHidden = true

            break
        default:
            tableMainForCurrentBldApp.isHidden = false
            oldAppTable.isHidden = true
        }
    }
    
    
    
    }

    
    
    
    


// update it

extension VolunteerBloodAppointmensViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       if tableView == oldAppTable {
           
           print("this is for old table inside count row method")

           return storedOldBldApp.count
            
         
        }
        
        // old app table
        else {
            
            print("this is for current table inside count row method")

             return storedCurrentBldApp.count
            
        }
        
      
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // current blood app table
        if  tableView == oldAppTable
       {
            
            print("this is for old table inside cell method")
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldBloodACell", for: indexPath) as! oldBloodAppTableViewCell

            let time = checkTime(time : storedOldBldApp[indexPath.row].time)
            
            
            let cityAndArea = "\(storedOldBldApp[indexPath.row].city) - \(storedOldBldApp[indexPath.row].area)"
            cell.hospitalName.text = storedOldBldApp[indexPath.row].name
            cell.date.text = storedOldBldApp[indexPath.row].date
            cell.time.text = "\(storedOldBldApp[indexPath.row].time) \(time)"
            cell.cityAndArea.text = cityAndArea
            
            
            cell.locBtn.tag = indexPath.row
            cell.locBtn.addTarget(self, action: #selector(askToOpenMapForOld(sender:)), for: .touchUpInside)
            return cell
            
        }
        
        else {
            
                
                print("this is for current table inside cell method")

                
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentBACell", for: indexPath) as! currentBldAppCell

            let time = checkTime(time : storedCurrentBldApp[indexPath.row].time)
            
            
            let cityAndArea = "\(storedCurrentBldApp[indexPath.row].city) - \(storedCurrentBldApp[indexPath.row].area)"
            cell.hospitalName.text = storedCurrentBldApp[indexPath.row].name
            cell.date.text = storedCurrentBldApp[indexPath.row].date
            cell.time.text = "\(storedCurrentBldApp[indexPath.row].time) \(time)"
            cell.cityAndArea.text = cityAndArea
            
            cell.cancelAppBtn.tag = indexPath.row
            cell.editAppBtn.tag = indexPath.row
            
            cell.cancelAppBtn.addTarget(self, action: #selector(cancelAppointment(sender:)), for: .touchUpInside)
            
            
            cell.locBtn.tag = indexPath.row
            cell.locBtn.addTarget(self, action: #selector(askToOpenMapForCurrent(sender:)), for: .touchUpInside)
            return cell
            }
        
        
    }
    

    @objc
    func askToOpenMapForOld(sender : UIButton) {
    
    let lat = storedOldBldApp[sender.tag].lat
    let long = storedOldBldApp[sender.tag].long
    
    OpenMapDirections.present(in: self, sourceView: sender , latitude: lat, longitude: long , popUp : mapsAvailablePopUp , popUpMsg : mapPopUpMsg , blurredView: blurredView)
  }
    
    @objc
    func askToOpenMapForCurrent(sender : UIButton) {
    
    let lat = storedCurrentBldApp[sender.tag].lat
    let long = storedCurrentBldApp[sender.tag].long
    
    OpenMapDirections.present(in: self, sourceView: sender , latitude: lat, longitude: long , popUp : mapsAvailablePopUp , popUpMsg : mapPopUpMsg , blurredView: blurredView)
  }

    
    
    // when canceling the appointment make the date & time available again
    @objc
    func cancelAppointment(sender: UIButton) {
        
        // show pop up with 2 options
        // if click yes >> delete app from both volunteer and hospital
        // for yes we need : hospital uid , app uid ( make app uid same in hospital and volunteer )
        // if click no >> discard pop up
        
        // appID to be deleted
        clickedCellIndex = sender.tag
        CancelBtnOnCellClicked(index : sender.tag)

        
    }//end cancel button method
    
    
    func CancelBtnOnCellClicked(index : Int){
        
        // make it hidden again
        let time = checkTime(time : storedCurrentBldApp[index].time)
        clickedCellIndex = index
        bldAppHospitalName.text = storedCurrentBldApp[index].name
        bldAppDate.text = storedCurrentBldApp[index].date
        bldAppTime.text = "\(storedCurrentBldApp[index].time) \(time)"
        blurredView.isHidden = false
        deleteAppPopUp.isHidden = false
        
    }
    
    
    
    
    
    func checkTime(time : String) -> String{
        
        let str = time.prefix(2)
        var morningOrEvening : String = ""
        if Double(str)! < 12 {
            
            morningOrEvening = ("صباحًا")
        }
        else if Double(str)! >= 12 {
            
            morningOrEvening = ("مساءً")
        }
        
        return morningOrEvening
    }
    
    
} // end extension











// nothing to change
extension VolunteerBloodAppointmensViewController{
    
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentedControl.changeUnderlinePosition()
        print("index changed")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.setupSegment()
    }
    
    
}


/*
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
    /*
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
    */
}

*/
