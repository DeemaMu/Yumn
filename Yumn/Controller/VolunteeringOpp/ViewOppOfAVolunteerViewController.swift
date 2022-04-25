//
//  ViewOppOfAVolunteerViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 22/09/1443 AH.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation
import Firebase
import MaterialDesignWidgets

class ViewOppOfAVolunteerViewController: UIViewController ,CustomSegmentedControlDelegate {
    func change(to index: Int) {
        
    }
    
    @IBOutlet weak var currentVOppTable: UITableView!
    @IBOutlet weak var oldVOppTable: UITableView!
    
    @IBOutlet weak var noCurrentVOppLabel: UILabel!
    @IBOutlet weak var noOldVOppLabel: UILabel!
   
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

   
    var currentVOpp: [volunteerVOpp] = []
    var oldVOpp: [volunteerVOpp] = []
    let db = Firestore.firestore()
    // VOpp id : applicant state
    var VOppDict: [String : String] = [:]
    
    var codeSegmented:CustomSegmentedControl? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change names
        currentVOppTable.isHidden = false
        oldVOppTable.isHidden = true
        noCurrentVOppLabel.isHidden = true
        
        currentVOppTable.dataSource = self
        oldVOppTable.dataSource = self
        
        
        // register tables
        
        
        currentVOppTable.register(UINib(nibName: "viewCurrentVolunteerOppTableViewCell", bundle: nil), forCellReuseIdentifier: "currentVOPPCell")
        
        
        oldVOppTable.register(UINib(nibName: "viewOldVolunteerOppTableViewCell", bundle: nil), forCellReuseIdentifier: "oldVOPPCell")
        
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["التطوعات السابقة","التطوعات الحالية"])
        codeSegmented!.backgroundColor = .clear
        //        segmentsView.addSubview(codeSegmented!)
        
        
        codeSegmented?.delegate = self
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.removeBorder()
        segmentedControl.addUnderlineForSelectedSegment()
        
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
    
    
    func getCurrentVOpp(userID : String) {
        
        // جب لي ال vOpp اللي الابلكنتس فيها اليوزر اي دي هذا
     
        // اجيب الدوكس بالسب كولكشن واشيك اذا فيها اليوزر اي دي ولا لا ، اذا فيها اجيب الدوكيمنت تبع هذا الكولكشن
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        print("current date is \(currentDate)")
        
        
        // only bring docs that their endDate isGreaterThanOrEqualTo current date
        db.collection("volunteeringOpp").whereField("endDate", isGreaterThanOrEqualTo: currentDate).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noCurrentVOppLabel.isHidden = true
                    // for each doc check if the user id exists in applicants subcollection or not
                for document in querySnapshot!.documents {
                    
                     let docID : String = document.documentID
                        
                    // check if applicant with the same user id exists in docID VOpp
                        self.checkApplicantExists(docID : docID , userID: userID)

                      //  self.applicantDoc(uid: uid, applicantType: "current")
                     //   self.reloadCurrentTable()
                    
                } // end for
                    
                    // after looping through all the docs in volunteeringOpp bring the data of the docs from VOppList
                    
                    // maybe put it in the loop ?
                    self.bringVoppData(type : "current")
                    // maybe commented
                    self.reloadCurrentTable()

                
            }// end if stm
                
                else {
                    self.showCurrentVoppLbl()
                    self.reloadCurrentTable()
                   
                }
                
            } // end else
        }
        
        
        
    }
    
    
    
    func getOldVOpp(userID : String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        print("current date is \(currentDate)")
        
        
        // only bring docs that their endDate isLessThan current date
        db.collection("volunteeringOpp").whereField("endDate", isLessThan: currentDate).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noOldVOppLabel.isHidden = true
                    // for each doc check if the user id exists in applicants subcollection or not
                for document in querySnapshot!.documents {
                    
                     let docID : String = document.documentID
                        
                    // check if applicant with the same user id exists in docID VOpp
                        self.checkApplicantExists(docID : docID , userID: userID)

                      //  self.applicantDoc(uid: uid, applicantType: "current")
                     //   self.reloadCurrentTable()
                    
                } // end for
                    
                    // after looping through all the docs in volunteeringOpp bring the data of the docs from VOppList
                    
                    // maybe put it in the loop ?
                    self.bringVoppData(type : "old")
                    // maybe commented
                    self.reloadOldTable()

                
            }// end if stm
                
                else {
                    self.showOldVoppLbl()
                    self.reloadOldTable()
                   
                }
                
            } // end else
        }
    }
    
    
    
    
    
    func checkApplicantExists(docID : String, userID : String){
        
        // if applicant exists add the docID to the dictionary VOppDict, otherwise return
        
        // make VOppDict empty for current and old
        VOppDict = [:]
        
        let docRef = db.collection("volunteeringOpp").document(docID).collection("applicants").document(userID)
        
        docRef.getDocument { (document, error) in
            if document!.exists {
                 print("Document \(userID) exists")
                if let data = document!.data(){
                    // add docID + applicant state to dictionary
                    self.VOppDict[docID] = (data["status"] as! String)
                    
                }
              } else {
                 print("Document \(userID) does not exist")
              }
        }
        
        
    }
    
    func bringVoppData(type : String){
        
        // shouldn't we create different dictionary for old VOpp ?
        // loop through the docs and get them
        // key >> docID, value >> applicant state
        for (key,value) in VOppDict {
            
            let docRef = db.collection("volunteeringOpp").document(key)
            
            docRef.getDocument { (document, error) in
                if document!.exists {
                     print("VOpp document exists")
                    // get data
                    if let data = document?.data(){
                        let title : String = data["title"] as! String
                        //let date : String = data["date"] as! String
                        let endDate : String = data["endDate"] as! String
                        let startDate : String = data["startDate"] as! String
                        let workingHours : String = data["workingHours"] as! String
                        let location : String = data["location"] as! String
                        let status : String = value
                    
                        if type == "current"{
                            self.currentVOpp.append(volunteerVOpp(title: title, endDate: endDate, startDate: startDate, workingHours: workingHours, location: location, status: status))
                            self.reloadCurrentTable()
                        }
                        else // type == old
                        {
                            self.oldVOpp.append(volunteerVOpp(title: title, endDate: endDate, startDate: startDate, workingHours: workingHours, location: location))
                            self.reloadOldTable()
                        }
                    
                    }// end data
                    
                    
                  } else {
                     print("VOpp document does not exist")
                  }
            }
            
        }// end for
        
    }
    
   
    
    func showCurrentVoppLbl(){
        
        if currentVOpp.count == 0 {
            noCurrentVOppLabel.isHidden = false
            noOldVOppLabel.isHidden = true
        }
        
    }
    
    func showOldVoppLbl(){
        if oldVOpp.count == 0 {
       noCurrentVOppLabel.isHidden = true
       noOldVOppLabel.isHidden = false
        }
    }
    
    
    func reloadCurrentTable(){
        
        DispatchQueue.main.async {
            self.currentVOppTable.reloadData()

        }
        
    }
    
    func reloadOldTable(){
        DispatchQueue.main.async {
            self.oldVOppTable.reloadData()

        }
        
    }
    
    
    // nothing to change
    func addSegments(){
        
        let segments = ["التطوعات السابقة","التطوعات الحالية"]
        
        // change color
        let sgLine = MaterialSegmentedControlR(selectorStyle: .line, fgColor: .gray, selectedFgColor: UIColor.init(named: "mainLight")!, selectorColor: UIColor.init(named: "mainLight")!, bgColor: .white)
        
        
        guard let customFont = UIFont(name: "Tajawal", size: 15) else {
            fatalError("""
                             Failed to load the "Tajawal" font.
                             Make sure the font file is included in the project and the font name is spelled correctly.
                             """
            )
        }
        
        // change color
        segmentsView.addSubview(sgLine)
        
        for i in 0..<2 {
            sgLine.appendTextSegment(text: segments[i], textColor: .gray, font: customFont, rippleColor: #colorLiteral(red: 0.4438726306, green: 0.7051679492, blue: 0.6503567696, alpha: 0.5) , cornerRadius: CGFloat(0))
            
        }
        
        sgLine.frame = CGRect(x: 2, y: 2, width: segmentsView.frame.width - 4 , height: segmentsView.frame.height - 4)
        
        sgLine.addTarget(self, action: #selector(selectedSegment), for: .valueChanged)
        
        segmentsView.addSubview(sgLine)
        segmentsView.semanticContentAttribute = .forceRightToLeft
    }

    
    // change tables names
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
        switch sender.selectedSegmentIndex {
        case 0:
           
            currentVOppTable.isHidden = true
            oldVOppTable.isHidden = false
            noCurrentVOppLabel.isHidden = true
            
            showOldVoppLbl()
            
         
            break
        case 1:
   
            currentVOppTable.isHidden = false
            oldVOppTable.isHidden = true
            noOldVOppLabel.isHidden = true
            
            showCurrentVoppLbl()

            break
        default:
            currentVOppTable.isHidden = false
            oldVOppTable.isHidden = true
        }
    }
    
   

}



extension ViewOppOfAVolunteerViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == currentVOppTable {
            
            return currentVOpp.count
        }
        else {
            
            return oldVOpp.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == currentVOppTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentVOPPCell", for: indexPath) as! viewCurrentVolunteerOppTableViewCell
            
            let date = "\(currentVOpp[indexPath.row].startDate) - \(currentVOpp[indexPath.row].endDate)"
            // make sure of it from deema's code
            cell.title.text = currentVOpp[indexPath.row].title
            cell.date.text = date
            cell.workingHours.text = currentVOpp[indexPath.row].workingHours
            cell.location.text = currentVOpp[indexPath.row].location
        // must bring state from somewhere else + create new model for it
            //   cell.state.text = currentVOpp[indexPath.row].state
            
            
            // button
            cell.locationBtn.tag = indexPath.row

            
          //  cell.locationBtn.addTarget(self, action: #selector(acceptCurrentApplicant(sender:)), for: .touchUpInside)
            
            
            return cell
            
        }
        
        else { // old table
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldVOPPCell", for: indexPath) as! viewOldVolunteerOppTableViewCell
            
            let date = "\(oldVOpp[indexPath.row].startDate) - \(oldVOpp[indexPath.row].endDate)"
            // make sure of it from deema's code
            cell.title.text = oldVOpp[indexPath.row].title
            cell.date.text = date
            cell.workingHours.text = oldVOpp[indexPath.row].workingHours
            cell.location.text = oldVOpp[indexPath.row].location
            
            // button
            cell.locationBtn.tag = indexPath.row
            
            //  cell.locationBtn.addTarget(self, action: #selector(acceptCurrentApplicant(sender:)), for: .touchUpInside)
            
            return cell

        }
    }
    
    
    
    
    
}
