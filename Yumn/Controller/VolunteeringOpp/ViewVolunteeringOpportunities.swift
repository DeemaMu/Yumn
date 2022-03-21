//
//  ViewVolunteeringOpportunities.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class ViewVolunteeringOpportunities: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var VolunteeringOppsList: UICollectionView!
    
    var VolunteeringOpps = [VolunteeringOpp]()
    
    @IBOutlet weak var noVolunteeringOPPLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noVolunteeringOPPLabel.isHidden = true
    }
    
    
    func loadOPP(){
        VolunteeringOpps.removeAll()
        let db = Firestore.firestore()
        
        
        db.collection("volunteeringOpp").order(by: "postDate", descending: false).getDocuments() { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            if documents.isEmpty {
                print("No documents 2")
                DispatchQueue.main.async {
                    self.VolunteeringOppsList.reloadData()
                }
                
                self.noVolunteeringOPPLabel.isHidden = false
            } else {
                
                
                self.noVolunteeringOPPLabel.isHidden = true
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let postedBy = data["posted_by"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let workingHours = data["workingHours"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let docID = document.documentID
                    
                    var vop = VolunteeringOpp(title: title, date: date, workingHours: workingHours, location: location, gender: gender, description: description, id :docID)
                    
                    
                    self.VolunteeringOpps.append(vop)
                    
                    DispatchQueue.main.async {
                        self.VolunteeringOppsList.reloadData()
                    }
                    
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VolunteeringOpps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let VOP = VolunteeringOpps[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "volunteerVOCell", for: indexPath) as! ViewVOCollectionViewCell
        
        cell.title.text = VOP.title
        cell.date.text = VOP.date
        cell.gender.text = VOP.gender
        cell.hours.text = VOP.workingHours
        cell.des.text = VOP.description
        cell.location.text = VOP.location
        
        cell.apply.tag = indexPath.row
        cell.apply.addTarget(self, action: #selector(applytoVO), for: .touchUpInside)
        
        
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
    
    @objc func applytoVO(_ sender : UIButton) {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = VolunteeringOpps[indexPath.row]
        var applied = false
        
        // Check if already applied

        DispatchQueue.main.async {
            
            db.collection("volunteeringOpp").document(cell.id).collection("applicants").document(uid!).getDocument() { (querySnapshot, error) in
                
                guard let documents = querySnapshot?.data() else {
                    db.collection("volunteeringOpp").document(cell.id).collection("applicants").document(uid!).setData([
                        "uid": uid!]){ error in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                print ("Error in Apply")
                            }
                            
                            // Success msg
                        }
                    return
                }
                // Show Message
            print("YOU CANt")
            }
            
            
            
        }
            // confirmation pop up
            
            
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOPP()
        
    }
    
}
