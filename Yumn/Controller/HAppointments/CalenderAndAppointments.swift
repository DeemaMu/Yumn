//
//  CalenderAndAppointments.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import SwiftUI

struct CalenderAndAppointments: View {
    
    @State var currentDate: Date=Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                CustomDatePicker(currentDate: $currentDate)
            }
        }
    }
}

struct CalenderAndAppointments_Previews: PreviewProvider {
    static var previews: some View {
        CalenderAndAppointments()
    }
}
