//
//  ViewApplicantsViewController.swift
//  testingFeatures
//
//  Created by Modhi Abdulaziz on 09/09/1443 AH.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation
import Firebase
import MaterialDesignWidgets

class ViewApplicantsViewController: UIViewController, CustomSegmentedControlDelegate {
    func change(to index: Int) {
        
    }
    

    
@IBOutlet weak var currentApplicantsTable: UITableView! // current applicatns table
@IBOutlet weak var questionLabel: UILabel!
@IBOutlet weak var acceeptOrRejectHeadline: UILabel!
@IBOutlet weak var acceptBtn: UIButton! // make it rounded
@IBOutlet weak var cancelBtn: UIButton!
@IBOutlet weak var popUp: UIView!
    
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    @IBOutlet weak var acceptedApplicantsTable: UITableView!
    
    @IBOutlet weak var noApplicantsLabel: UILabel!
    @IBOutlet weak var noAcceptedApplicantsLbl: UILabel!
    @IBOutlet weak var blurredView: UIView!
    
    
    // populate it with a method
    var currentApplicants: [applicant] = []
    var acceptedApplicants: [applicant] = []
    var clickedCellIndex: Int = -1
    let db = Firestore.firestore()
    
    // from segue | Updated
    var VODocID = ""
    
    // By Modhi
   // let user = Auth.auth().currentUser

    
    var codeSegmented:CustomSegmentedControl? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 17
        acceptBtn.layer.cornerRadius = 12
        acceptBtn.layer.masksToBounds = true
        
        
        currentApplicantsTable.isHidden = false
        acceptedApplicantsTable.isHidden = true
        noApplicantsLabel.isHidden = true
        
        currentApplicantsTable.dataSource = self
        acceptedApplicantsTable.dataSource = self
        
        // register tables
        
        
        currentApplicantsTable.register(UINib(nibName: "currentApplicantTableViewCell", bundle: nil), forCellReuseIdentifier: "currentApplicantCell")
        
        
        acceptedApplicantsTable.register(UINib(nibName: "acceptedApplicantTableViewCell", bundle: nil), forCellReuseIdentifier: "acceptedApplicantCell")
        
        if VODocID != "" {
        print("Doc ID of VOpp is \(VODocID)")
        getCurrentApplicants(docID: VODocID)
        getAcceptedApplicants(docID: VODocID)
        }
        
        guard let customFont = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        // font style
        questionLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        questionLabel.adjustsFontForContentSizeCategory = true
        questionLabel.font = questionLabel.font.withSize(15)
        
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["المتقدمين المقبولين","المتقدمين الحاليين"])
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

     //   let navigationController: UINavigationController = self.navigationController!

      VODocID = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        VODocID = ""
    }
    
    
    // docID fron segue
    //4duFZ8QsjfxWDqzoRhpq
    // from applicants we wil bring the uid pf the app with status == pending
    // sva e the uids in array then bring info
    func getCurrentApplicants(docID:String){
        
        print("Doc ID of VOpp in current is \(VODocID)")
        
        db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "pending").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                
                if querySnapshot!.documents.isEmpty == false {
                    self.noApplicantsLabel.isHidden = true
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    if let uid : String = doc["uid"] as? String{
                        
                        self.applicantDoc(uid: uid, applicantType: "current")
                        self.reloadCurrentTable()
                    }
                    
                    
                } // end for
            }
                else {
                    self.showCurrentAppLbl()
                }
                
                self.reloadCurrentTable()
                
            } // end else
        }
        
        
        
    }// end func
    

    func applicantDoc(uid : String, applicantType : String){
        
        self.acceptedApplicants = []
       
        db.collection("volunteer").document(uid).getDocument { (document, error) in
                 if let document = document, document.exists {
                     let docData = document.data()
                     
                     let firstName : String = docData!["firstName"] as! String
                     let lastName : String = docData!["lastName"] as! String
                     let DOB : String = docData!["birthDate"] as! String
                     let email : String = docData!["email"] as! String
                     let ciry : String = docData!["city"] as! String
                     let id : String = document.documentID
                     
                     if  applicantType == "current"{
                         self.currentApplicants.append(applicant(uid: id, firstName: firstName, lastName: lastName, DOB: DOB, email: email, city: ciry))
                         
                         self.reloadCurrentTable()
                         
                     }
                     else {
                         
                         
                         self.acceptedApplicants.append(applicant(uid: uid, firstName: firstName, lastName: lastName, DOB: DOB, email: email, city: ciry))
                         
                         self.reloadAcceptedTable()
                     }
                 } else {
                     print("Volunteer document does not exist")

                  }
    }
    } // end func
    
   
    
    func getAcceptedApplicants(docID : String){

     //   self.acceptedApplicants = []
        let userRef = db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "accepted")
        userRef.addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print ("there was a problem fetching accepted applicants \(e)")
            }
                
                if let snapshotDocuments = querySnapshot?.documents{
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data["uid"] as? String{
                            self.applicantDoc(uid: uid, applicantType: "accepted")
                            
                            self.reloadAcceptedTable()
                           
                        }
                        
                        
                    }
                }
                
            
        }
            
    }// end func
    
    
    @IBAction func acceptBtnOnPopup(_ sender: Any) {
        
        let type = acceeptOrRejectHeadline.text
       
        
        if type == "قبول المتقدم"{
            
            acceptApplicantMthod()
           
            
        }
        
        // reject
        else if type == "رفض المتقدم"{
            
            rejectApplicantMthod()
       
        }
        
        // retrive points then update it
        else if type == "حضور المتقدم" {
            
            markApplicantAsAttendMthod()
            
           
          
        }
        
        
        
        
        
        // applicant did not attend
        else {
            
            markApplicantAsDNAttendMthod()
           
            
        }
        
        
    } // end func
    
    
    @IBAction func cancelBtnOnPopup(_ sender: Any) {
        self.blurredView.isHidden = true
        self.popUp.isHidden = true
    }
    
    
    func showCurrentAppLbl(){
        
        if currentApplicants.count == 0 {
            noApplicantsLabel.isHidden = false
            noAcceptedApplicantsLbl.isHidden = true
        }
    }
    
    func showAcceptedAppLbl(){
        if acceptedApplicants.count == 0 {
            noApplicantsLabel.isHidden = true
            noAcceptedApplicantsLbl.isHidden = false
        }
    }
    
    func hidePopupAndBlurredView(){
        self.blurredView.isHidden = true
        self.popUp.isHidden = true

    }
    
    func showPopupAndBlurredView(){
        self.blurredView.isHidden = false
        self.popUp.isHidden = false
    }
    
    func reloadCurrentTable(){
        
        DispatchQueue.main.async {
            self.currentApplicantsTable.reloadData()

        }
        
    }
    
    func reloadAcceptedTable(){
        DispatchQueue.main.async {
            self.acceptedApplicantsTable.reloadData()

        }
        
    }
    
    
    
    func acceptApplicantMthod(){
        
        let docID = currentApplicants[clickedCellIndex].uid

        let ref = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
        ref.updateData(["status": "accepted"]) { (error) in
                if error == nil {
                    
                    components().showToast(message: "تم قبول المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    self.currentApplicants.remove(at: self.clickedCellIndex)
                    
                    self.reloadCurrentTable()
                    self.reloadAcceptedTable()
                    
                    self.hidePopupAndBlurredView()
                    
                    self.showCurrentAppLbl()

                    
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء قبول المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                }
                
            }
        updateStatusInVolunteerDoc(status: "accepted", type: "current")
    }
    
    
    
    func rejectApplicantMthod(){
        
        let docID = currentApplicants[clickedCellIndex].uid

        let ref = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
    
        ref.updateData(["status": "rejected"]) { (error) in
                if error == nil {
                    
                    components().showToast(message: "تم رفض المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    self.currentApplicants.remove(at: self.clickedCellIndex)
                    
                   
                    self.reloadCurrentTable()
                    self.reloadAcceptedTable()
                    
                    self.hidePopupAndBlurredView()
                    
                    self.showCurrentAppLbl()
                    
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء رفض المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                }
                
            }
        
        updateStatusInVolunteerDoc(status: "rejected", type: "current")
        
    }
    
    
    
    func markApplicantAsAttendMthod(){
        var points = 0
        
        let docID = acceptedApplicants[clickedCellIndex].uid
        
        let ref = db.collection("volunteer").document(docID)
        let refToAppInOpp = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)

        
        // bring applicant points
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
               // print("Document data: \(data)")
                points = data!["points"] as! Int
                print("applicant points are \(points)")
            } else {
                print("Document does not exist")
            }
        }
        
       
    // update status
        refToAppInOpp.updateData(["status": "attended"]) { (error) in
                if error == nil {
                    // maybe deleted
                    self.acceptedApplicants.remove(at: self.clickedCellIndex)
                    // increase points
                    points += 50
                    // update applicant points
                    print("points after addition \(points)")
                    ref.updateData(["points": points]) { (error) in
                            if error == nil {
                                
                              
                                self.hidePopupAndBlurredView()
                                self.reloadCurrentTable()
                                self.reloadAcceptedTable()
                                
                                components().showToast(message: "تم تأكيد حضور المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                                
                              
                                self.showAcceptedAppLbl()
                                
                               
                                
                            }else{
                                
                                components().showToast(message: "حدثت مشكلة أثناء تأكيد حضور المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                                
                            }
                            
                        }

                   
                    
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء تأكيد حضور المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                }
                
            }
        
        updateStatusInVolunteerDoc(status: "attended", type: "accepted")
        
       
        
    }// end func
    
    
    
    
    func markApplicantAsDNAttendMthod(){
        
        let docID = acceptedApplicants[clickedCellIndex].uid
        
        let refToAppInOpp = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
        // DNAttend == did not attend
        refToAppInOpp.updateData(["status": "DNAttend"]) { (error) in
                if error == nil {
                    // maybe deleted
                    self.acceptedApplicants.remove(at: self.clickedCellIndex)
                    
                    self.hidePopupAndBlurredView()
                    self.reloadCurrentTable()
                    self.reloadAcceptedTable()
                    
                    components().showToast(message: "تم تأكيد عدم حضور المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                  
                    self.showAcceptedAppLbl()
                    
                   
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء تأكيد عدم حضور المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                }
        }
            
        updateStatusInVolunteerDoc(status: "DNAttended", type: "accepted")
    }
    
    
    func updateStatusInVolunteerDoc(status : String, type : String){
        var docID = ""
        
        if type == "accepted"{
            docID = acceptedApplicants[clickedCellIndex].uid}
        else {
            docID = currentApplicants[clickedCellIndex].uid
        }
        
        let ref = db.collection("volunteer").document(docID)
        
        // update status in volunteer collection
        ref.collection("volunteeringOpps").whereField("mainDocId", isEqualTo: VODocID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                
                if querySnapshot!.documents.isEmpty == false {
                    
                for document in querySnapshot!.documents {
                    
                    ref.collection("volunteeringOpps").document(document.documentID).updateData([
                        "status": status
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                   
                    
                } // end for
            }
                
                
            } // end else
        }
    }
    
    
    
    // nothing to change
    func addSegments(){
        
        let segments = ["المتقدمين المقبولين","المتقدمين الحاليين"]
        
        // change color
        let sgLine = MaterialSegmentedControlR(selectorStyle: .line, fgColor: .gray, selectedFgColor: UIColor.init(named: "mainDark")!, selectorColor: UIColor.init(named: "mainDark")!, bgColor: .white)
        
        
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


    
    
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
        switch sender.selectedSegmentIndex {
        case 0:
           
            currentApplicantsTable.isHidden = true
            acceptedApplicantsTable.isHidden = false
            noApplicantsLabel.isHidden = true
            
            showAcceptedAppLbl()
            
         
            break
        case 1:
   
            currentApplicantsTable.isHidden = false
            acceptedApplicantsTable.isHidden = true
            noAcceptedApplicantsLbl.isHidden = true
            
            showCurrentAppLbl()

            break
        default:
            currentApplicantsTable.isHidden = false
            acceptedApplicantsTable.isHidden = true
        }
    }
    
    
    
    
}


extension ViewApplicantsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if tableView == currentApplicantsTable {
            
            return currentApplicants.count
        }
        else {
            
            return acceptedApplicants.count
        }
    }
    
    
    // calculate age
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if tableView == currentApplicantsTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentApplicantCell", for: indexPath) as! currentApplicantTableViewCell
            
            let name = "\(currentApplicants[indexPath.row].firstName) \(currentApplicants[indexPath.row].lastName)"
            cell.name.text = name
            let age = getAge(type: "current", index: indexPath.row)
            cell.age.text = "\(String(age)) عامًا"
            cell.email.text = currentApplicants[indexPath.row].email
            cell.cityAndArea.text = currentApplicants[indexPath.row].city
            
            
            // buttons
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            
            cell.acceptBtn.addTarget(self, action: #selector(acceptCurrentApplicant(sender:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(rejectCurrentApplicant(sender:)), for: .touchUpInside)
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "acceptedApplicantCell", for: indexPath) as! acceptedApplicantTableViewCell
            
            let name = "\(acceptedApplicants[indexPath.row].firstName) \(acceptedApplicants[indexPath.row].lastName)"
            cell.name.text = name
            let age = getAge(type: "accepted", index: indexPath.row)
            cell.age.text = "\(String(age)) عامًا"
            cell.email.text = acceptedApplicants[indexPath.row].email
            cell.cityAndArea.text = acceptedApplicants[indexPath.row].city
            
            // buttons
            cell.attendBtn.tag = indexPath.row
            cell.didNotAttendBtn.tag = indexPath.row
            
            cell.attendBtn.addTarget(self, action: #selector(acceptedApplicantAttended(sender:)), for: .touchUpInside)
            cell.didNotAttendBtn.addTarget(self, action: #selector(acceptedApplicantDidNotAttend(sender:)), for: .touchUpInside)

            
            return cell
            
            
        }
    
    
    
    }
    
    func formatAge(age : String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let DOB = dateFormatter.date(from: age)
        return DOB!
        
    }
    
    func getAge(type : String, index : Int)->Int {
        
        
        if type == "current"{
            let birthday = formatAge(age: currentApplicants[index].DOB)
            let timeInterval = birthday.timeIntervalSinceNow
            let age = abs(Int(timeInterval / 31556926.0))
            return age
        }
        else if type == "accepted"{
            let birthday = formatAge(age: acceptedApplicants[index].DOB)
            let timeInterval = birthday.timeIntervalSinceNow
            let age = abs(Int(timeInterval / 31556926.0))
            return age
        }
        
        return 0
        
    }
    
    
    @objc
    // remove applicant from currentApplicants
    // first show pop up
    func acceptCurrentApplicant(sender: UIButton) {
        
        clickedCellIndex = sender.tag
       // let docID = currentApplicants[clickedCellIndex].uid
        let name = "\(currentApplicants[clickedCellIndex].firstName) \(currentApplicants[clickedCellIndex].lastName)"
        acceeptOrRejectHeadline.text = "قبول المتقدم"
        questionLabel.text = "هل أنت متأكد من قبول \(name)؟"
        showPopupAndBlurredView()
        
        
    }
    
    
    @objc
    // remove applicant from currentApplicants
    func rejectCurrentApplicant(sender: UIButton) {
        
        clickedCellIndex = sender.tag
        print(clickedCellIndex)
       // let docID = currentApplicants[clickedCellIndex].uid
        let name = "\(currentApplicants[clickedCellIndex].firstName) \(currentApplicants[clickedCellIndex].lastName)"
        acceeptOrRejectHeadline.text = "رفض المتقدم"
        questionLabel.text = "هل أنت متأكد من رفض \(name)؟"
        showPopupAndBlurredView()
        
    }
    
    
    @objc
    
    func acceptedApplicantAttended(sender: UIButton) {
        
        // increase the applicant points + change status
        clickedCellIndex = sender.tag
        let name = "\(acceptedApplicants[clickedCellIndex].firstName) \(acceptedApplicants[clickedCellIndex].lastName)"
        acceeptOrRejectHeadline.text = "حضور المتقدم"
        questionLabel.text = "هل أنت متأكد من تأكيد حضور \(name)؟"
        showPopupAndBlurredView()
        
     
    }
    
    
    @objc
   
    func acceptedApplicantDidNotAttend(sender: UIButton) {
        
        // change status
        clickedCellIndex = sender.tag
        let name = "\(acceptedApplicants[clickedCellIndex].firstName) \(acceptedApplicants[clickedCellIndex].lastName)"
        acceeptOrRejectHeadline.text = "عدم حضور المتقدم"
        questionLabel.text = "هل أنت متأكد من تأكيد عدم حضور \(name)؟"
        showPopupAndBlurredView()
        
    }
    
}// end of extension


extension ViewApplicantsViewController{
    
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentedControl.changeUnderlinePosition()
        print("index changed")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.setupSegment()
    }
    
    
}
