//
//  DateController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import Foundation
import Firebase



struct BloodDonationController {
    
}

extension BloodDonationAppointmentViewController{
    
    
    func getAvailableAppointmentsDate() -> [BloodDonationDate]{
        
        
        var availableDates: [BloodDonationDate] = []
        
        let db = Firestore.firestore()
        
        
        //db.collection("")
        
        return availableDates
    }
}
