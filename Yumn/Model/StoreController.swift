//
//  StoreController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/05/2022.
//

import Foundation
import Firebase
import FirebaseAuth


struct StoreController {
}

extension AllStoresViewController{
    

    
    func getAllStores() -> [Store]{
     
        var allStores:[Store] = []

       
        let db = Firestore.firestore()

        // Add a condition to get only the user's QR codes
        db.collection("store").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting the documents:  \(err)")
            } else {
                for document in
                        querySnapshot!.documents{
                    let doc = document.data()
                    
                    
                    let Name: String = doc["name"] as! String
                    
                    let Instagram: String = doc["instagram"] as! String
                    
                    allStores.append(Store(name: Name, insta: Instagram))
                    
                    
                }
                self.sortedStores = allStores
                self.sortedStores = allStores.sorted(by: { (s0: Store, s1: Store) -> Bool in
                    return s0.name < s1.name})
                
                //validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                        //return QR0.amount < QR1.amount
                    //})
           

                 DispatchQueue.main.async {
                        self.allStoresTable.reloadData()
                    }
                

                    
                    
                    
                    
                    
                }
            
            
            if (self.sortedStores != nil){
            
            
            if (self.sortedStores!.isEmpty){
                
                print ("empty valid qr")
                
                self.allStoresTable.isHidden = true
                
               
                    
                    
          
                self.noStoresLabel.isHidden = false
                self.storesImage.isHidden = false
                

                
                

            }
            
            else {
                self.noStoresLabel.isHidden = true
                self.storesImage.isHidden = true
            }
            }}
            
            let sortedStores2 = self.sortedStores = allStores.sorted(by: { (s0: Store, s1: Store) -> Bool in
                return s0.name < s1.name})
        
    

        return sortedStores!
        
        
            
        

            
        }
    
    
    

    
    

    
    
    
    
    
}
