//
//  viewAppointment.swift
//  Yumn
//
//  Created by Deema Almutairi on 26/04/2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class viewAppointment: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var appointmentsList: UICollectionView!
    @IBOutlet weak var periodLabel: UILabel!
    
    var appointments = [DAppointment]()
    var docID = ""
    var period = ""
    var type = ""
    var donorDocID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 40
        periodLabel.text = period
        //        fetchData()
        appointmentsList.reloadData()
        
        // Update collection
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "updateOnStatus"), object: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.backView {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func refresh() {
        
        self.fetchData() // a refresh the collectionView.
        
    }
    func fetchData(){
        appointments.removeAll()
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        db.collection("appointments").document(docID).collection("appointments").order(by: "start_time", descending: false).addSnapshotListener() { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.appointments.removeAll()
            
            if documents.isEmpty {
                print("No documents 2")
                DispatchQueue.main.async {
                    self.appointmentsList.reloadData()
                }
            } else {
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let booked = data["booked"] as? Bool
                    
                    let confirmed = data["confirmed"] as? String ?? ""
                    
                    let donor = data["donor"] as? String ?? ""
                    
                    let hospital = data["hospital"] as? String ?? ""
                    
                    let stamp1 = data["start_time"] as? Timestamp
                    let start_time = stamp1!.dateValue()
                    
                    let stamp2 = data["end_time"] as? Timestamp
                    let end_time = stamp2!.dateValue()
                    
                    let type = data["type"] as? String ?? ""
                    
                    let docId = document.documentID
                    
                    if(booked!){
                        let docRef = db.collection("volunteer").document(donor)
                        
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                let data = document.data()
                                let firstName = data!["firstName"] as? String ?? ""
                                let lastName = data!["lastName"] as? String ?? ""
                                
                                let fullName = firstName + " " + lastName
                                
                                var appointment = DAppointment(id: donor, type: type, docID: docId, startTime: start_time, endTime: end_time, donor: fullName, hName: hospital, confirmed: confirmed, booked: booked!)
                                
                                self.appointments.append(appointment)
                                
                                DispatchQueue.main.async {
                                    self.appointmentsList.reloadData()
                                }
                                
                            } else {
                                print("Document does not exist")
                            }
                        }
                    } else {
                        var appointment = DAppointment(id: donor, type: type, docID: docId, startTime: start_time, endTime: end_time, donor: "", hName: hospital, confirmed: confirmed, booked: booked!)
                        self.appointments.append(appointment)
                        
                        DispatchQueue.main.async {
                            self.appointmentsList.reloadData()
                        }
                    }
                    
                    
                    
                    
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let appointment = appointments[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appointmentCell", for: indexPath) as! appointmentCollectionCell
        
        cell.time.text = getTime(appointment)
        
        if(appointment.booked){
            cell.donor.text = appointment.donor
            // Show buttons
            cell.complete.isHidden = false
            cell.incomplete.isHidden = false
            
            if(appointment.confirmed == "Complete"){
                cell.completeView.isHidden = false
                
                // Hide buttons
                cell.complete.isHidden = true
                cell.incomplete.isHidden = true
                
            } else if(appointment.confirmed == "Incomplete"){
                cell.inCompleteView.isHidden = false
                
                // Hide buttons
                cell.complete.isHidden = true
                cell.incomplete.isHidden = true
            }
        } else{
            // Hide buttons
            cell.complete.isHidden = true
            cell.incomplete.isHidden = true
            
            cell.donor.text = "لا احد حتى الان"
        }
        
        
        // Styling Buttons
        guard let customFont = UIFont(name: "Tajawal", size: 12) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        cell.complete.setAttributedTitle(NSAttributedString(string: "تم التبرع", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)
        cell.incomplete.setAttributedTitle(NSAttributedString(string: "لم يتبرع", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)
        
        cell.completeView.font? = UIFont(name: "Tajawal", size: 12)!
        cell.inCompleteView.font? = UIFont(name: "Tajawal", size: 12)!
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.3)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.8
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        // Actions
        cell.complete.tag = indexPath.row
        cell.complete.addTarget(self, action: #selector(completeAppointment), for: .touchUpInside)
        
        cell.incomplete.tag = indexPath.row
        cell.incomplete.addTarget(self, action: #selector(incompleteAppointment), for: .touchUpInside)
        
        return cell
    }
    
    func getTime(_ appointment : DAppointment) -> String {
        let time = "\(appointment.startTime.getFormattedDate(format: "HH:mm"))-\(appointment.endTime.getFormattedDate(format: "HH:mm"))"
        return time
    }
    
    @objc func completeAppointment(_ sender : UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = appointments[indexPath.row]

        updateStatus(cell.docID,"Complete")
        updatePoints(cell.id)

        self.performSegue(withIdentifier: "confirmAppointmentPopup", sender: self)
    }
    
    @objc func incompleteAppointment(_ sender : UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = appointments[indexPath.row]
        
        updateStatus(cell.docID,"Incomplete")

        self.performSegue(withIdentifier: "confirmAppointmentPopup", sender: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func updateStatus(_ id : String, _ status : String){
        DispatchQueue.main.async {
            
            let db = Firestore.firestore()
            let docRef = db.collection("appointments").document(self.docID).collection("appointments").document(id)
            
            
            docRef.updateData([
                "confirmed": status]){ error in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        print ("Error in updating appointment status")
                    }
                }
        }
    }
    
    func updatePoints(_ id : String){
        DispatchQueue.main.async {
            
            let db = Firestore.firestore()
            let volunteerDoc = db.collection("volunteer").document(id)
            volunteerDoc.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let points = data!["points"] as? Int
                    var addedPoints = points!
                    if (self.type == "Blood"){
                        addedPoints = addedPoints + 100
                    } else if (self.type == "Organ"){
                        addedPoints = addedPoints + 1000
                    }
                    
                    volunteerDoc.updateData([
                        "points": addedPoints]){ error in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                print ("Error in updating appointment status")
                            }
                        }
                }
                else {
                    print("Document does not exist")
                }
            }
        }
    }
    
}
