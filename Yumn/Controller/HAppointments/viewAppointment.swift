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
    
    @IBOutlet weak var appointmentsList: UICollectionView!
    @IBOutlet weak var periodLabel: UILabel!
    
    var appointments = [DAppointment]()
    var docID = ""
    var period = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        periodLabel.text = period
        fetchData()
        appointmentsList.reloadData()
        
    }
    
    func fetchData(){
        appointments.removeAll()
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        db.collection("appointments").document(docID).collection("appointments").order(by: "start_time", descending: false).getDocuments() { (querySnapshot, error) in
            
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
                    
                    let confirmed = data["confirmed"] as? Bool
                    
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
                                
                                print(fullName)
                                
                                var appointment = DAppointment(id: donor, type: type, docID: docId, startTime: start_time, endTime: end_time, donor: fullName, hName: hospital, confirmed: confirmed!, booked: booked!)
                                
                                self.appointments.append(appointment)
                                
                                
                            } else {
                                print("Document does not exist")
                            }
                        }
                    } else {
                        var appointment = DAppointment(id: donor, type: type, docID: docId, startTime: start_time, endTime: end_time, donor: "", hName: hospital, confirmed: confirmed!, booked: booked!)
                        self.appointments.append(appointment)
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.appointmentsList.reloadData()
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
        
        cell.donor.text = appointment.donor
        cell.time.text = getTime(appointment)
        
//        if(appointment.confirmed == "Complete"){
//            cell.completeView.isHidden = false
//        } else if(appointment.confirmed == "Incomplete"){
//            cell.inCompleteView.isHidden = false
//        }
        
        // Styling Buttons
        
        
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
        
        return cell
    }
    
    func getTime(_ appointment : DAppointment) -> String {
        let time = "\(appointment.startTime.getFormattedDate(format: "HH:mm"))-\(appointment.endTime.getFormattedDate(format: "HH:mm"))"
        return time
    }
    
}
