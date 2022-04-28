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



class olderAppointmensVC: UIViewController {
    
    
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
    
    
    @IBOutlet weak var oldAppTable: UITableView!
    
    @IBOutlet weak var noAppLabel: UILabel!
    @IBOutlet weak var mapsAvailablePopUp: UIView!
    
    @IBOutlet weak var noOldAppLbl: UILabel!
    @IBOutlet weak var mapPopUpBtn: UIButton!
    @IBOutlet weak var mapPopUpMsg: UILabel!
    @IBOutlet weak var blurredView: UIView!
    
    
    var storedOldBldApp: [bloodAppointment] = []
    var storedCurrentBldApp: [bloodAppointment] = []
    var clickedCellIndex: Int = -1
    
    @IBOutlet weak var currentVOppTable: UITableView!
    @IBOutlet weak var oldVOppTable: UITableView!
    
    @IBOutlet weak var noCurrentVOppLabel: UILabel!
    @IBOutlet weak var noOldVOppLabel: UILabel!
   
    var currentVOpp: [volunteerVOpp] = []
    var oldVOpp: [volunteerVOpp] = []
    
    
    var VOppDict: [String : String] = [:]
    var arrayOfOldVOpp : [String] = []
    
    let user = Auth.auth().currentUser
    
    
    var codeSegmented:CustomSegmentedControl? = nil
    
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        oldAppTable.isHidden = false
        tableMainForCurrentBldApp.isHidden = true
        
        
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
        
        // change names
        currentVOppTable.isHidden = true
        oldVOppTable.isHidden = true
        noCurrentVOppLabel.isHidden = true
        
        currentVOppTable.dataSource = self
        oldVOppTable.dataSource = self
        
        
        // register tables
        
        
        currentVOppTable.register(UINib(nibName: "viewCurrentVolunteerOppTableViewCell", bundle: nil), forCellReuseIdentifier: "currentVOPPCell")
        
        
        oldVOppTable.register(UINib(nibName: "viewOldVolunteerOppTableViewCell", bundle: nil), forCellReuseIdentifier: "oldVOPPCell")
        
        // put user id (auth)
        getCurrentVOpp(userID: user!.uid)
        getOldVOpp(userID: user!.uid)
        
        
        // on index change
        getOldAppointments(userID:user!.uid)
        
        
        
        
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
        
        
        //MARK: Editied
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
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
    
    
    func getOldAppointments(userID : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'+3"
       // dateFormatter.dateFormat = "MMMM d, yyyy HH:mm:sss"
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date() - 7 )
        print("current date is \(currentDate)")
        
       
                

        db.collection("volunteer").document(userID).collection("bloodAppointments").whereField("date", isLessThan: currentDate).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noOldAppLbl.isHidden = true
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

                    self.reloadOldTable()
                
            }// end if stm
                
                else {
                    print("in old bld app")
                   // self.showOldAppLbl()
                }
                
            } // end else
        }
        

    }// end func/ end func
    
    @IBAction func cancelingAppDelete(_ sender: Any) {
        
     
        hidePopupAndBlurredView()
        
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
                
                self.hidePopupAndBlurredView()
                components().showToast(message: "تم حذف الموعد بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
            }
        }
        
    }
    
    
    
    @IBAction func okayMapBtn(_ sender: Any) {
       
        
        hidePopupAndBlurredView()
    }
    
    
    
    func showCurrentAppLbl(){
        
        if storedCurrentBldApp.count == 0 {
            noAppLabel.isHidden = false
            noOldAppLbl.isHidden = true
        }
    }
    
    
    func showOldAppLbl(){
        
        if storedOldBldApp.count == 0 {
            noAppLabel.isHidden = true
            noOldAppLbl.isHidden = false
        }
    }
    
    
    func hidePopupAndBlurredView(){
        self.blurredView.isHidden = true
        self.deleteAppPopUp.isHidden = true

    }
    
    func showPopupAndBlurredView(){
        self.blurredView.isHidden = false
        self.deleteAppPopUp.isHidden = false
    }
    
    func reloadCurrentTable(){

        DispatchQueue.main.async {
            self.tableMainForCurrentBldApp.reloadData()

        }

    }

    func reloadOldTable(){
        DispatchQueue.main.async {
            self.oldAppTable.reloadData()

        }

    }
    
    
    
    
    func addSegments(){
        //MARK: Editied
        
        var segments = [
            "التبرع بالدم",
            "التبرع بالاعضاء",
            "التطوع"
        ]
        segments.reverse()
        
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
    
    
    
    // update it
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
        switch sender.selectedSegmentIndex {
        case 0:
            
            tableMainForCurrentBldApp.isHidden = true
            oldAppTable.isHidden = true
            
            currentVOppTable.isHidden = true
            oldVOppTable.isHidden = false
            noCurrentVOppLabel.isHidden = true
            
            showOldVoppLbl()
            
            break
        case 1:
            
            tableMainForCurrentBldApp.isHidden = true
            oldAppTable.isHidden = true
            
            break
        default:
            tableMainForCurrentBldApp.isHidden = true
            oldAppTable.isHidden = false
            noAppLabel.isHidden = true
            currentVOppTable.isHidden = true
            oldVOppTable.isHidden = true
            noCurrentVOppLabel.isHidden = true
            showOldAppLbl()
            
        }
    }
    
    
    
}







// update it

extension olderAppointmensVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       if tableView == oldAppTable {
           
           print("this is for old table inside count row method")

           return storedOldBldApp.count
            
         
        }
//
//        // old app table
//        else {
//
//            print("this is for current table inside count row method")
//
//             return storedCurrentBldApp.count
//
//        }
        
        if tableView == currentVOppTable {
            
            return currentVOpp.count
        }
        else {
            
            return oldVOpp.count
        }
        
      
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customFont = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }

        
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
        
//        else {
//
//
//                print("this is for current table inside cell method")
//
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "currentBACell", for: indexPath) as! currentBldAppCell
//
//            let time = checkTime(time : storedCurrentBldApp[indexPath.row].time)
//
//
//            let cityAndArea = "\(storedCurrentBldApp[indexPath.row].city) - \(storedCurrentBldApp[indexPath.row].area)"
//            cell.hospitalName.text = storedCurrentBldApp[indexPath.row].name
//            cell.date.text = storedCurrentBldApp[indexPath.row].date
//            cell.time.text = "\(storedCurrentBldApp[indexPath.row].time) \(time)"
//            cell.cityAndArea.text = cityAndArea
//
//            cell.cancelAppBtn.tag = indexPath.row
//            cell.editAppBtn.tag = indexPath.row
//
//            cell.cancelAppBtn.addTarget(self, action: #selector(cancelAppointment(sender:)), for: .touchUpInside)
//
//
//            cell.locBtn.tag = indexPath.row
//            cell.locBtn.addTarget(self, action: #selector(askToOpenMapForCurrent(sender:)), for: .touchUpInside)
//            return cell
//            }
        
        if tableView == currentVOppTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentVOPPCell", for: indexPath) as! viewCurrentVolunteerOppTableViewCell
            
           
            cell.title.text = currentVOpp[indexPath.row].title
            cell.title.font = UIFontMetrics.default.scaledFont(for: customFont)
            cell.title.adjustsFontForContentSizeCategory = true
            cell.title.font = cell.title.font.withSize(16)
            
            cell.date.text = currentVOpp[indexPath.row].date
            cell.workingHours.text = currentVOpp[indexPath.row].workingHours
            cell.location.text = currentVOpp[indexPath.row].location
            
            let status = currentVOpp[indexPath.row].status
            if status == "pending"{
                cell.state.text = "في الانتظار"
                cell.state.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)

            }
            else if status == "accepted" {
                cell.state.text = "مقبول"
                cell.state.textColor = UIColor(red: 0.00, green: 0.55, blue: 0.27, alpha: 1.00)
            }
            else if status == "rejected" {
                cell.state.text = "مرفوض"
                cell.state.textColor = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
            }
        // must bring state from somewhere else + create new model for it
            //   cell.state.text = currentVOpp[indexPath.row].state
            
            
            // button
            cell.locationBtn.tag = indexPath.row

            
          //  cell.locationBtn.addTarget(self, action: #selector(acceptCurrentApplicant(sender:)), for: .touchUpInside)
            
            
            return cell
            
        }
        
        else { // old table
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldVOPPCell", for: indexPath) as! viewOldVolunteerOppTableViewCell
            
            cell.title.text = oldVOpp[indexPath.row].title
            cell.title.font = UIFontMetrics.default.scaledFont(for: customFont)
            cell.title.adjustsFontForContentSizeCategory = true
            cell.title.font = cell.title.font.withSize(16)
            cell.date.text = oldVOpp[indexPath.row].date
            cell.workingHours.text = oldVOpp[indexPath.row].workingHours
            cell.location.text = oldVOpp[indexPath.row].location
            
            // button
            cell.locationBtn.tag = indexPath.row
            
            //  cell.locationBtn.addTarget(self, action: #selector(acceptCurrentApplicant(sender:)), for: .touchUpInside)
            
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
      //  blurredView.isHidden = false
       // deleteAppPopUp.isHidden = false
        showPopupAndBlurredView()
        
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
extension olderAppointmensVC {
    
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentedControl.changeUnderlinePosition()
        print("index changed")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.setupSegment()
    }
    
    
}
