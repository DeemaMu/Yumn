//
//  AfterDeathDonor.swift
//  Yumn
//
//  Created by Deema Almutairi on 22/04/2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AfterDeathDonor: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var donorsList: UICollectionView!
    var donors = [Donor]()
    @IBOutlet weak var noDonorsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
    
    func loadData(){
        donors.removeAll()
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        db.collection("afterDeathDonors").order(by: "name", descending: true).getDocuments() { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.donors.removeAll()
            
            if documents.isEmpty {
                print("No documents 2")
                DispatchQueue.main.async {
                    self.donorsList.reloadData()
                }
                
                self.noDonorsLabel.isHidden = false
            } else {
                
                
                self.noDonorsLabel.isHidden = true
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let name = data["name"] as? String ?? ""
                    let city = data["city"] as? String ?? ""
                    let organs = data["organs"] as? String ?? ""
                    let bloodType = data["bloodType"] as? String ?? ""
                    let nationalID = data["nationalID"] as? String ?? ""
                    
                    //                    let docID = document.documentID
                    
                    var donor = Donor(name: name, city: city, bloodType: bloodType, organs: organs,nationalID: nationalID)
                    
                    self.donors.append(donor)
                    
                    DispatchQueue.main.async {
                        self.donorsList.reloadData()
                    }
                    
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let donor = donors[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donorCell", for: indexPath) as! DonorCollectionViewCell
        
        cell.name.text = donor.name
        cell.id.text = donor.nationalID
        cell.city.text = donor.city
        cell.organs.text = donor.organs
        cell.bloodType.image = getImage(donor.bloodType)
        
        
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
    
    func getImage(_ type: String) -> UIImage {
        if(type == "O+"){
            return UIImage.init(named: "Op")!
        }
        if(type == "O-"){
            return UIImage.init(named: "Om")!
        }
        if(type == "A+"){
            return UIImage.init(named: "Ap")!
        }
        if(type == "A-"){
            return UIImage.init(named: "Am")!
        }
        if(type == "B+"){
            return UIImage.init(named: "Bp")!
        }
        if(type == "AB+"){
            return UIImage.init(named: "ABp")!
        }
        if(type == "AB-"){
            return UIImage.init(named: "ABm")!
        }
        return UIImage.add
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


