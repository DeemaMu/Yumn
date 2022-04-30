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
        
        
        db.collection("appointments").document("2rQwtfO2gKed0ugsDD5R").collection("appointments").whereField("hospital", isEqualTo: Constants.Globals.hospitalId).whereField("type", isEqualTo:  "blood")
.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting the documents:  \(err)")
            } else {
                
                //Search inside the other appointment collection

               /* for document in
                        querySnapshot!.documents{
                    
                 
                    
                    
                    db.collection("appointments").document(document.documentID).collection("appointments").whereField("booked", isEqualTo: false).whereField("start_time", in: [selectedDate]).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print ("Error getting the documents:  \(err)")
                        } else {
                            */
                            for document in
                                    querySnapshot!.documents{
                                let doc = document.data()
                                
                                let docID:String =  document.documentID
                                
                                let startDate:Timestamp = doc["start_time"] as! Timestamp
                                let endDate:Timestamp = doc["end_time"] as! Timestamp
                                
                                let startDate2:Date = startDate.dateValue()
                                let endDate2:Date = endDate.dateValue()

                                

                                let formatter = DateFormatter()
                                
                                formatter.dateFormat = "dd/MM/YYYY"
                                let start_time:String = formatter.string(from: startDate2)
                                let end_time:String = formatter.string(from: endDate2)
                                
                                
                                
                                availableTimes.append(BloodDonationTime(startTime: start_time, endTime: end_time, appointmentID: docID))
                           // }
                                
                            
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
    


        
        return availableTimes
    }
}
    
