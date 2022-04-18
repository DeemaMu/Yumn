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
    
    // cancel btn
    // pop up
    
    @IBOutlet weak var segmentsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    @IBOutlet weak var acceptedApplicantsTable: UITableView!
    
    @IBOutlet weak var noApplicantsLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    
    
    // populate it with a method
    var currentApplicants: [applicant] = []
    var acceptedApplicants: [applicant] = []
    var clickedCellIndex: Int = -1
    let db = Firestore.firestore()
    
    // from segue
    let VODocID = "4duFZ8QsjfxWDqzoRhpq"

    
    // By Modhi
   // let user = Auth.auth().currentUser

    
    var codeSegmented:CustomSegmentedControl? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentApplicantsTable.isHidden = false
        acceptedApplicantsTable.isHidden = true
        
        currentApplicantsTable.dataSource = self
        acceptedApplicantsTable.dataSource = self
        
        // register tables
        
        
        currentApplicantsTable.register(UINib(nibName: "currentApplicantTableViewCell", bundle: nil), forCellReuseIdentifier: "currentApplicantCell")
        
        
        acceptedApplicantsTable.register(UINib(nibName: "acceptedApplicantTableViewCell", bundle: nil), forCellReuseIdentifier: "acceptedApplicantCell")
        
        
        getCurrentApplicants(docID: VODocID)
       // getAcceptedApplicants(docID: VODocID)
        angilaGetAccepted(docID: VODocID)
        //acceptedApplicantListener(docID: VODocID)
        
        
        
        
        
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
    
    
    // docID fron segue
    //4duFZ8QsjfxWDqzoRhpq
    // from applicants we wil bring the uid pf the app with status == pending
    // sva e the uids in array then bring info
    func getCurrentApplicants(docID:String){
        
        var applicantsUIDs : [String] = []
        
        db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "pending").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noApplicantsLabel.isHidden = true
                    //self.currentApplicantsTable.isHidden = false
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    if let uid : String = doc["uid"] as? String{
                        
                        applicantDoc(uid: uid, applicantType: "current")
                    }
                    
                    
                }
                    
                DispatchQueue.main.async {
                    self.currentApplicantsTable.reloadData()
                }
                
            }// end if stm
                
                else {
                  //  self.currentApplicantsTable.isHidden = true
                    self.noApplicantsLabel.text = "لا يوجد متقدمين حاليين"
                    self.noApplicantsLabel.isHidden = false
                    print("no available current applicants")
                }
                
            } // end else
        }
        
        
        
    }// end func
    
    // docID fron segue
    func getAcceptedApplicants(docID:String){
        
        //var applicantsUIDs : [String] = []
        
        db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "accepted").getDocuments() { [self]  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count != 0 {
                    self.noApplicantsLabel.isHidden = true
                    //self.currentApplicantsTable.isHidden = false
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    if let uid : String = doc["uid"] as? String{
                        
                        self.applicantDoc(uid: uid, applicantType: "accepted")
                    }
                   // applicantsUIDs.append(uid)
                    
                }
                    
                  //  self.bringApplicantData(applicantsUIDs: applicantsUIDs, applicantType: "accepted")

                DispatchQueue.main.async {
                    self.acceptedApplicantsTable.reloadData()
                }
                
            }// end if stm
                
                else {
                    self.currentApplicantsTable.isHidden = true
                    self.noApplicantsLabel.text = "لا يوجد متقدمين مقبولين"
                    self.noApplicantsLabel.isHidden = false
                    print("no available accepted applicants")
                }
                
            } // end else
        }
    }
    
    func applicantDoc(uid : String, applicantType : String){
        
        
        db.collection("volunteer").document(uid).getDocument { (document, error) in
                 if let document = document, document.exists {
                     let docData = document.data()
                     print("Volunteer document exists")
                     
                     let firstName : String = docData!["firstName"] as! String
                     let lastName : String = docData!["lastName"] as! String
                     let DOB : String = docData!["birthDate"] as! String
                     let email : String = docData!["email"] as! String
                     let ciry : String = docData!["city"] as! String
                     let uid : String = document.documentID
                     
                     if  applicantType == "current"{
                         self.currentApplicants.append(applicant(uid: uid, firstName: firstName, lastName: lastName, DOB: DOB, email: email, city: ciry))
                         
                         DispatchQueue.main.async {
                             self.currentApplicantsTable.reloadData()
                         }
                         
                     }
                     else {
                         self.acceptedApplicants.append(applicant(uid: uid, firstName: firstName, lastName: lastName, DOB: DOB, email: email, city: ciry))
                         
                         DispatchQueue.main.async {
                             self.acceptedApplicantsTable.reloadData()
                         }
                     }
                 } else {
                     print("Volunteer document does not exist")

                  }
    }
    } // end func
    
   /*
    func acceptedApplicantListener(docID : String) {
       // let uid = "uid_0" //this is the logged in user
        acceptedApplicants = []
        self.noApplicantsLabel.isHidden = true
        let userRef = db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "accepted")
        //let postsRef = userRef.collection("Posts")
        userRef.addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot else {
                print("err fetching snapshots")
                return
            }
            if snapshot.isEmpty{
                self.noApplicantsLabel.text = "لا يوجد متقدمين مقبولين"
                self.noApplicantsLabel.isHidden = false
                print("no available accepted applicants")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let doc = diff.document
                //let applicantId = doc.documentID
                let uid  = doc.get("uid") as! String

                if (diff.type == .added) { //will initially populate the array or add new posts
                    print("added accepted applicant \(uid)")
                   // self.applicantDoc(uid : uid, applicantType: "accepted")
                    
                    
                    
                    self.db.collection("volunteer").document(uid).getDocument { (document, error) in
                             if let document = document, document.exists {
                                 let docData = document.data()
                                 print("Volunteer document exists")
                                 
                                 let firstName : String = docData!["firstName"] as! String
                                 let lastName : String = docData!["lastName"] as! String
                                 let DOB : String = docData!["birthDate"] as! String
                                 let email : String = docData!["email"] as! String
                                 let ciry : String = docData!["city"] as! String
                                 let uid : String = document.documentID
                                 print("volunteer is  \(uid)")
                                 print("array count is  \(self.acceptedApplicants.count)")

                                 self.acceptedApplicants.append(applicant(uid: uid, firstName: firstName, lastName: lastName, DOB: DOB, email: email, city: ciry))
                                 
                             } else {
                                 print("Volunteer document does not exist")

                              }
                }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.acceptedApplicantsTable.reloadData()
                    }
                    //let aPost = UserPostClass(theId: postId, theText: postText, theLikes: numLikes)
                    //self.postArray.append(aPost)
                }

                if (diff.type == .modified) { //called when there are changes
                    //find the post that was modified by it's postId
                    //let resultsArray = self.postArray.filter { $0.postId == postId }
                    let resultsArray = self.acceptedApplicants.filter { $0.uid == uid }
                   /* if let postToUpdate = resultsArray.first {
                        postToUpdate.likes = numLikes
                    }*/
                }

                if (diff.type == .removed) {

                    print("handle removed")
                }
            }
            //this is just for testing. It prints all of the posts
            // when any of them are modified
            /*for doc in snapshot.documents {
                let postId = doc.documentID
                let postText = doc.get("post") as! String
                let numLikes = doc.get("likes") as! Int
                print(postId, postText, numLikes)
            }*/
            
        }
    }
    */
    
    func angilaGetAccepted(docID : String){
        
        acceptedApplicants = []
        let userRef = db.collection("volunteeringOpp").document(docID).collection("applicants").whereField("status", isEqualTo: "accepted")
        userRef.addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print ("there was a problem fetching accepted applicants \(e)")
            }
            else if querySnapshot!.documents.count != 0 {
                //
                self.noApplicantsLabel.isHidden = true

                if let snapshotDocuments = querySnapshot?.documents{
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data["uid"] as? String{
                            self.applicantDoc(uid: uid, applicantType: "accepted")
                           // let applicant = applicantDoc(uid: uid, applicantType: "accepted")
                            
                            DispatchQueue.main.async {
                                self.acceptedApplicantsTable.reloadData()
                            }
                           
                        }
                        
                        
                    }
                }
            } // else
            else {
               // self.currentApplicantsTable.isHidden = true
                self.noApplicantsLabel.text = "لا يوجد متقدمين مقبولين"
                self.noApplicantsLabel.isHidden = false
                print("no available accepted applicants")
                
            }
        }
    
            
            
    }
    
    
    
    func addSegments(){
        
        let segments = ["المتقدمين المقبولين","المتقدمين الحاليين"]
        
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


    
    
    @objc func selectedSegment(_ sender: MaterialSegmentedControlR) {
        switch sender.selectedSegmentIndex {
        case 0:
           
            currentApplicantsTable.isHidden = true
            acceptedApplicantsTable.isHidden = false
         
            break
        case 1:
   
            currentApplicantsTable.isHidden = false
            acceptedApplicantsTable.isHidden = true
            

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
            print(currentApplicants.count)
            return currentApplicants.count
        }
        else {
            print(acceptedApplicants.count)
            return acceptedApplicants.count
        }
    }
    
    
    // calculate age
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == currentApplicantsTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentApplicantCell", for: indexPath) as! currentApplicantTableViewCell
            
            let name = "\(currentApplicants[indexPath.row].firstName) \(currentApplicants[indexPath.row].lastName)"
            cell.name.text = name
        //    cell.age.text = String(currentApplicants[indexPath.row].age) // must be calculated frpm DOB
            cell.age.text = "22" // must be removed
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
           // cell.age.text = String(acceptedApplicants[indexPath.row].age) // must be calculated frpm DOB
            cell.age.text = "22" // must be removed
            cell.email.text = acceptedApplicants[indexPath.row].email
            cell.cityAndArea.text = acceptedApplicants[indexPath.row].city
            
            // buttons
            cell.attendBtn.tag = indexPath.row
            cell.didNotAttendBtn.tag = indexPath.row
            
            cell.attendBtn.addTarget(self, action: #selector(acceptedApplicantAttended(sender:)), for: .touchUpInside)

            
            return cell
            
            
        }
    
    
    
    }
    
    @objc
    // remove applicant from currentApplicants
    // first show pop up
    func acceptCurrentApplicant(sender: UIButton) {
        
        clickedCellIndex = sender.tag
        print(clickedCellIndex)
        let docID = currentApplicants[clickedCellIndex].uid
        let ref = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
        
        
        ref.updateData(["status": "accepted"]) { (error) in
                if error == nil {
                    
                    components().showToast(message: "تم قبول المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    self.currentApplicants.remove(at: self.clickedCellIndex)
                    self.currentApplicantsTable.reloadData()
                    self.acceptedApplicantsTable.reloadData()
                    
                    
                    print("status updated (accepted)")
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء قبول المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    print("status not updated (accepted)")
                }
                
            }
        
        
        
    }
    
    
    @objc
    // remove applicant from currentApplicants
    func rejectCurrentApplicant(sender: UIButton) {
        
        clickedCellIndex = sender.tag
        print(clickedCellIndex)
        let docID = currentApplicants[clickedCellIndex].uid
        let ref = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
    
        ref.updateData(["status": "rejected"]) { (error) in
                if error == nil {
                    
                    components().showToast(message: "تم رفض المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    self.currentApplicants.remove(at: self.clickedCellIndex)
                    self.currentApplicantsTable.reloadData()
                    
                    print("status updated (rejected)")
                }else{
                    
                    components().showToast(message: "حدثت مشكلة أثناء رفض المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    print("status not updated (rejected)")
                }
                
            }
    
    }
    
    
    @objc
    // remove applicant from acceptedApplicants
    func acceptedApplicantAttended(sender: UIButton) {
        
       /* clickedCellIndex = sender.tag
        print(clickedCellIndex)
        let docID = acceptedApplicants[clickedCellIndex].uid
        let ref = db.collection("volunteeringOpp").document(VODocID).collection("applicants").document(docID)
    
        ref.updateData(["status": "pending"]) { (error) in
                if error == nil {
                    
                    //components().showToast(message: "تم رفض المتقدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    self.acceptedApplicants.remove(at: self.clickedCellIndex)
                    self.acceptedApplicantsTable.reloadData()
                    
                    print("status updated (rejected)")
                }else{
                    
                    //components().showToast(message: "حدثت مشكلة أثناء رفض المتقدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
                    
                    print("status not updated (rejected)")
                }
                
            }*/
    
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
