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
                    Text(extraDate()[0]).font(.caption).fontWeight(.semibold)
                    Text(extraDate()[1]).font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation{currentMonth -=  1}
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation{currentMonth +=  1}
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
//                    Text("\(value.day)")
//                        .font(.title3.bold())
                    CardView(value: value)
                }
            }
        }.onChange(of: currentMonth) {
            newValue in
            // updating month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue)-> some View{
        VStack{
            if value.day != -1 {
                Text("\(value.day)").font(.title3.bold())
            }
        }
        
    }
    
    
    // extracting year and month for display
    func extraDate()-> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date{
        let calender = Calendar.current
        
        // getting current month
        guard let currentMonth = calender.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calender = Calendar.current
        
        // getting current month
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            // getting day
            let day = calender.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        // adding dates offset
        
        let firstWeekday = calender.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
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
        
        let range = calender.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calender.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
