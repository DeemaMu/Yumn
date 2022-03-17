//
//  CustomDatePicker.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var currentDate: Date
    
    // month update on button clicks
    @State var currentMonth: Int = 0
    
    var body: some View {
        
        VStack(spacing: 35){
            
            //days
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack(spacing: 20){
                
                VStack(alignment: .leading, spacing: 10){
                    Text("2022").font(.caption).fontWeight(.semibold)
                    Text("March").font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                
            }.padding(.horizontal)
            
            // days view
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    
                    Text(day).font(.callout).fontWeight(.semibold).frame(maxWidth: .infinity)
                }
            }
            
            // dates
            // lazygrid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(extractDate()){ value in
                    Text("\(value.day)")
                        .font(.title3.bold())
                }
            }
        }
    }
    
    func extractDate() -> [DateValue] {
        let calender = Calendar.current
        
        // getting current month
        guard let currentMonth = calender.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return[]
        }
        
        return currentMonth.getAllDates().compactMap { date -> DateValue in
            
            // getting day
            let day = calender.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CalenderAndAppointments()
    }
}

// get all months dates
extension Date{
    
    func getAllDates()->[Date]{
        let calender = Calendar.current
        
        // getting start date
        let startDate = calender.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        var range = calender.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        
        return range.compactMap { day -> Date in
            return calender.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate)!
        }
    }
}
