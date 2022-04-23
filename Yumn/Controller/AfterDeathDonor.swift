//
//  AfterDeathDonor.swift
//  Yumn
//
//  Created by Deema Almutairi on 22/04/2022.
//

import Foundation
import UIKit

class AfterDeathDonor: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var donorsList: UICollectionView!
    
//    var VolunteeringOpps = [VolunteeringOpp]()
    var names = ["نوف","نوره","ديمه"]
    var ids = ["122111111","122111111","122111111"]
    var organs = ["جميع الاعضاء","الكبد","الكلى"]
    
    
    @IBOutlet weak var noDonorsLabel: UILabel!
    
    var passDocID = ""
    var notEditable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
//        noDonorsLabel.isHidden = true
        
//        guard let customFont = UIFont(name: "Tajawal", size: 18) else {
//            fatalError("""
//                Failed to load the "Tajawal" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
        
//        addVOPBtn.setAttributedTitle(NSAttributedString(string: "إضافة فرصة تطوع", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)
    }
    
//    @objc func refresh() {
//
//        self.loadOPP() // a refresh the collectionView.
//
//    }
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {}
    
    func loadOPP(){
//        VolunteeringOpps.removeAll()
//        let db = Firestore.firestore()
//        let user = Auth.auth().currentUser
//        let uid = user?.uid
//
//        db.collection("volunteeringOpp").order(by: "postDate", descending: true).getDocuments() { (querySnapshot, error) in
//
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//
//            self.VolunteeringOpps.removeAll()
//
//            if documents.isEmpty {
//                print("No documents 2")
//                DispatchQueue.main.async {
//                    self.VolunteeringOppsList.reloadData()
//                }
//
//                self.noVolunteeringOPPLabel.isHidden = false
//            } else {
//
//
//                self.noVolunteeringOPPLabel.isHidden = true
//
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    let postedBy = data["posted_by"] as? String ?? ""
//                    let title = data["title"] as? String ?? ""
//                    let date = data["date"] as? String ?? ""
//                    let workingHours = data["workingHours"] as? String ?? ""
//                    let location = data["location"] as? String ?? ""
//                    let gender = data["gender"] as? String ?? ""
//                    let description = data["description"] as? String ?? ""
//                    let docID = document.documentID
//
//                    var vop = VolunteeringOpp(title: title, date: date, workingHours: workingHours, location: location, gender: gender, description: description, id :docID)
//
//                    if (postedBy == uid){
//                        self.VolunteeringOpps.append(vop)
//                    }
//                    DispatchQueue.main.async {
//                        self.VolunteeringOppsList.reloadData()
//                    }
//
//
//                }
//            }
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let donor = names[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donorCell", for: indexPath) as! DonorCollectionViewCell
        
        cell.name.text = names[indexPath.row]
        cell.id.text = ids[indexPath.row]
        cell.organs.text = organs[indexPath.row]
        
        
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
        
//        guard let customFont = UIFont(name: "Tajawal", size: 14) else {
//            fatalError("""
//                Failed to load the "Tajawal" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
        
        return cell
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark")!, NSAttributedString.Key.font: customFont]
    }
    
    
    
}


