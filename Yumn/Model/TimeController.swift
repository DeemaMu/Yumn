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
        
        var selectedDate = Date()

        
        //Make a method to get the selected date
        for item in Constants.Globals.appointmentDateArray!{
            
            if (item.selected == true){
                selectedDate = item.date
            }
                
        }
                
        
        var availableTimes: [BloodDonationTime] = []
        
        let db = Firestore.firestore()
        
        
        db.collection("appointments").whereField("hospital", isEqualTo: Constants.Globals.hospitalId).whereField("type", isEqualTo: "blood")
.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting the documents:  \(err)")
            } else {
                
                //Search inside the other appointment collection

                for document in
                        querySnapshot!.documents{
                    
                 let selectedDateTimeStamp = selectedDate.timeIntervalSince1970

                    
                    db.collection("appointments").document(document.documentID).collection("appointments").whereField("booked", isEqualTo: false)
.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print ("Error getting the documents:  \(err)")
                        } else {
                            
                            let dateformat = DateFormatter()
                                   dateformat.dateFormat = "MM/dd/yyyy"
                                   let SDF =  dateformat.string(from: selectedDate)
                               
                            
                            //Get the selected date only
                            
                            
                            for document in
                                    querySnapshot!.documents{
                                let doc = document.data()
                                
                                print ( doc["start_time"] as! Timestamp)
                                
                                print (SDF+"sdf")
                                print(dateformat.string(from:(doc["start_time"] as! Timestamp).dateValue()))
                                
                                
                                if (SDF == dateformat.string(from:(doc["start_time"] as! Timestamp).dateValue())){
                                    
                                    dateformat.string(from: selectedDate)
     
                                let docID:String =  document.documentID
                                
                                let startDate:Timestamp = doc["start_time"] as! Timestamp
                                let endDate:Timestamp = doc["end_time"] as! Timestamp
                                
                                let startDate2:Date = startDate.dateValue()
                                let endDate2:Date = endDate.dateValue()
                                    
                                    
                                    

                                

                                let formatter = DateFormatter()
                                
                                formatter.dateFormat = "HH:mm"
                                let start_time:String = formatter.string(from: startDate2)
                                let end_time:String = formatter.string(from: endDate2)
                                
                                
                                
                                availableTimes.append(BloodDonationTime(startTime: start_time, endTime: end_time, appointmentID: docID))
                                
                                print (availableTimes)
                                print ("fffffff")
                                

                           // }
                                
                            
                            // I need to sort them
                                self.sortedTimes = availableTimes
                            
                            
                            print("sorted down")
                            print (self.sortedTimes)
                                
                            DispatchQueue.main.async {
                                   self.timeTableView.reloadData()
                               }
                                
                            }}
                    
                    
                    
                    
                }
                
            }
    

                }}}
        
        return availableTimes
    }
}
    
