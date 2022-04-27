//
//  TController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import Foundation
import Firebase


struct TController {
}

extension TViewController {
    
    func getTs() -> [T] {
        
        var ts:[T] = []
        
        db.collection("code").getDocuments() {(querySnapsot, err) in
            if let err = err {
                print ("err \(err)")
            } else {
                for document in querySnapsot!.documents{
                    let doc = document.data()
                    
                    let l = doc["id"] as! String
                    
                    
                    ts.append(T(label: l))
                }
                
                self.tArray = ts
                    print (ts)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                        
                    }

                
                
            }
        }
        return ts

    }
}
