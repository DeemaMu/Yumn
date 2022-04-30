//
//  TimeController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 30/04/2022.
//

import Foundation

import Foundation
import Firebase



struct TimeController {
    
}

extension BloodDonationAppointmentViewController{
    
    
    func getAvailableAppointmentsTimes() -> [BloodDonationTime]{
        
        //Make a method to get the selected date
        
        let selectedDate = Date()
        
        
        var availableTimes: [BloodDonationTime] = []
        
        let db = Firestore.firestore()
        
        
        db.collection("appointments").whereField("hospital", isEqualTo: Constants.Globals.hospitalId).whereField("type", isEqualTo:  "blood")
.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting the documents:  \(err)")
            } else {
                
                //Search inside the other appointment collection

                for document in
                        querySnapshot!.documents{
                    
                 
                    
                    
                    db.collection("appointments").document(document.documentID).collection("appointments").whereField("booked", isEqualTo: false).whereField("start_time", in: [selectedDate]).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print ("Error getting the documents:  \(err)")
                        } else {
                            
                            for document in
                                    querySnapshot!.documents{
                                let doc = document.data()
                                
                                let docID:String =  document.documentID
                                
                                let start_time:String = doc["start_time"] as! String
                                
                                let end_time:String = doc["end_time"] as! String
                                
                                availableTimes.append(BloodDonationTime(startTime: start_time, endTime: end_time, appointmentID: docID))
                            }
                                
                            
                            // I need to sort them
                                self.sortedTimes = availableTimes
                            
                            
                            print("sorted down")
                            print (self.sortedTimes)
                                
                            DispatchQueue.main.async {
                                   self.timeTableView.reloadData()
                               }
                                
                        }
                    
                    
                    
                    
                }
                
            }
    


            }}
        return availableTimes
    }
}
    
