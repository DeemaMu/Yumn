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
    
//    var names = ["ديمو"];
//    var times = ["11:00-1:00"];
    @IBOutlet weak var appointments: UICollectionView!
    
    var names = ["ديمو","ديدي","دودو"];
    var times = ["11:00-1:00","2:00-4:00","5:00-6:00"];
    override func viewDidLoad() {
        super.viewDidLoad()
        appointments.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let VOP = VolunteeringOpps[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appointmentCell", for: indexPath) as! appointmentCollectionCell
        
        cell.donor.text = names[indexPath.row]
        cell.time.text = times[indexPath.row]
        
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
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    
}
