//
//  CustomDatePicker.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/03/2022.
//

import SwiftUI
import Firebase

struct CustomDatePicker: View {
    
    @ObservedObject var aptVM = AppointmentVM()
    
    @State var showPopup: Bool = false
    @Binding var currentDate: Date
    
    
    
    @StateObject var overalyControl = OverlayControl()
    @Binding var controller: ManageAppointmentsViewController
    
    // month update on button clicks
    @State var currentMonth: Int = 0
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    
    
    var body: some View {
        
        
        if #available(iOS 15.0, *) {
            
            VStack(spacing: 10){
                
                //days
                let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                
                HStack(spacing: 20){
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(extraDate()[0]).font(Font.custom("Tajawal", size: 15)).fontWeight(.semibold)
                        Text(extraDate()[1]).font(Font.custom("Tajawal", size: 25)).fontWeight(.semibold)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        withAnimation{currentMonth -=  1}
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(mainDark)
                    }
                    
                    Button {
                        withAnimation{currentMonth +=  1}
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(mainDark)
                    }
                    
                }.padding(.horizontal, 30).padding(.vertical,10)
                
                // days view
                HStack(spacing: 0){
                    ForEach(days, id: \.self){ day in
                        
                        Text(day).font(Font.custom("Tajawal", size: 18)).fontWeight(.semibold).frame(maxWidth: .infinity)
                            .foregroundColor(mainLight)
                    }
                }.padding(.horizontal, 40)
                
                // dates
                // lazygrid
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 0){
                    ForEach(extractDate()){ value in
                        //                    Text("\(value.day)")
                        //                        .font(.title3.bold())
                        CardView(value: value)
                            .background(
                                Capsule().fill(mainDark)
                                    .padding(.horizontal, 4)
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            ).onTapGesture {
                                currentDate = value.date
                            }
                    }
                }.padding(.horizontal, 40)
                
                VStack(spacing: 15){
                    
                    HStack(spacing: 0){
                        
                        if(!checkAppointmentsForDay()){
                            
                            Button(action: {
                                Constants.selected.selectedDate = self.currentDate
                                controller.showOverlay(date: currentDate)
                                //                                showPopup.toggle()
                                //                                overalyControl.showOverlay.toggle()
                            }) {
                                Text("+").foregroundColor(.white).font(.title)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 11))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .frame(width: 40, height: 30)
                                
                            }.foregroundColor(.white)
                                .background(mainDark)
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        else {
                            
                            if #available(iOS 15.0, *) {
                                Button(action: {
                                    print("therse already a date")
                                    //                                    dispatch(.showOverlay(value: true))
                                    //                                    overalyControl.showOverlay.toggle()
                                    
                                }) {
                                    Text("+").foregroundColor(.white).font(.title)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 11))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .frame(width: 40, height: 30)
                                    
                                }.foregroundColor(.white)
                                    .background(lightGray)
                                    .cornerRadius(20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                        }
                        
                        
                        
                        Text("مواعيد التبرع بالدم")
                            .font(Font.custom("Tajawal", size: 17))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(mainDark)
                        
                        
                    }
                    
                    if let appointment = aptVM.appointments.first(where: { apt in
                        return ( isSameDayBlood(date1: apt.aptDate, date2: currentDate, type: apt.type) && (apt.hospital == Constants.UserInfo.userID))
                        
                    }) {
                        
                        
                        VStack(){
                            
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text("\(appointment.startTime.getFormattedDate(format: "HH:mm")) - \(appointment.endTime.getFormattedDate(format: "HH:mm"))")
                                    .font(Font.custom("Tajawal", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                //                                .foregroundColor(mainDark)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color("mainDark")
//                                    .opacity(0.8)
                                //                                .opacity(0.05)
                                    .cornerRadius(10)
                            )
                            //                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(mainLight, lineWidth: 1))
                        }.padding(.horizontal, 30)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                let time = "\(appointment.startTime.getFormattedDate(format: "HH:mm"))-\(appointment.endTime.getFormattedDate(format: "HH:mm"))"
                                let day = "\(appointment.startTime.getFormattedDate(format: "dd/MM/yyyy"))"
                                let period = day + ", " + time

                                controller.viewAppointments(appointment.docID, period,"Blood")
                            }
                        
                        
                    } else {
                        
                        Text("لايوجد مواعيد")
                            .font(Font.custom("Tajawal", size: 15))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(lightGray)
                            .opacity(50)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    
                }.padding()
                
                VStack(spacing: 15){
                    
                    HStack(){
                        Button(action: {
                            Constants.selected.selectedDate = self.currentDate
                            controller.showOverlayOrgan(date: currentDate)
                            print("button tapped")
                        }) {
                            Text("+").foregroundColor(.white).font(.title)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 11))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(width: 40, height: 30)
                            
                        }.foregroundColor(.white)
                            .background(mainDark)
                            .cornerRadius(20)
                            .frame(alignment: .leading)
                        
                        Text("مواعيد التبرع بالأعضاء")
                            .font(Font.custom("Tajawal", size: 17))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(mainDark)
                        
                    }
                    
//                    VStack(){
//                        for apt in aptVM.appointments {
//                            if(isSameDayOrgan(date1: apt.aptDate, date2: currentDate, type: apt.type)){
//
//                            }
//                        }
//                    }
                    
                    
                    let appointments = aptVM.appointments.filter { apt in
                        return isSameDayOrgan(date1: apt.aptDate, date2: currentDate, type: apt.type)
                    }
                    
                    if(!appointments.isEmpty)
                    {
                        
                        ForEach(0..<appointments.count, id: \.self) { index in
                            VStack(){


                                VStack(alignment: .leading, spacing: 10){
                                    Text("\(appointments[index].startTime.getFormattedDate(format: "HH:mm")) - \(appointments[index].endTime.getFormattedDate(format: "HH:mm"))")
                                        .font(Font.custom("Tajawal", size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)

                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    Color("mainDark")
//                                        .opacity(0.8)
                                        .cornerRadius(10)
                                )
                            }.padding(.horizontal, 30)
                                .padding(.vertical, 5)
                                .onTapGesture {
                                    let time = "\(appointments[index].startTime.getFormattedDate(format: "HH:mm"))-\(appointments[index].endTime.getFormattedDate(format: "HH:mm"))"
                                    let day = "\(appointments[index].startTime.getFormattedDate(format: "dd/MM/yyyy"))"
                                    let period = day + ", " + time

                                    controller.viewAppointments(appointments[index].docID, period,"Organ")
                                }
                        }

                    } else {

                        Text("لايوجد مواعيد")
                            .font(Font.custom("Tajawal", size: 15))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(lightGray)
                            .opacity(50)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                                        
                    
                    
                }.padding()
                
            }.onChange(of: currentMonth) {
                newValue in
                // updating month
                currentDate = getCurrentMonth()
            }
            .popupNavigationView(show: $showPopup){
                Text("hi")
            }.onAppear(){
                self.aptVM.fetchData()
            }
        } else {
        }
    }
    
    
    @ViewBuilder
    func CardView(value: DateValue)-> some View{
        VStack{
            if value.day != -1 {
                //                Text("\(value.day)").font(.title3.bold())
                
                if let appointment = aptVM.appointments.first(where: { apt in
                    return ( isSameDay(date1: apt.aptDate, date2: value.date) && (apt.hospital == Constants.UserInfo.userID) )
                    
                }) {
                    
                    Text("\(value.day)").font(Font.custom("Tajawal", size: 20))
                        .foregroundColor(isSameDay(date1: appointment.aptDate, date2: currentDate) ? .white : mainDark)
                        .frame(maxWidth: .infinity)
                    
                    Circle()
                        .fill(isSameDay(date1: appointment.aptDate, date2: currentDate) ? .white : mainDark)
                        .frame(width: 8, height: 8)
                    
                }
                else {
                    
                    Text("\(value.day)").font(Font.custom("Tajawal", size: 20))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .black)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                }
            }
        }.padding(.vertical, 9)
            .frame(height: 60, alignment: .top)
        
    }
    
    // checking dates
    func isSameDay(date1: Date, date2: Date)-> Bool {
        let calender = Calendar.current
        
        return calender.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameDayBlood(date1: Date, date2: Date, type: String)-> Bool {
        let calender = Calendar.current
        
        return (calender.isDate(date1, inSameDayAs: date2) && (type == "blood"))
    }
    
    func isSameDayOrgan(date1: Date, date2: Date, type: String)-> Bool {
        let calender = Calendar.current
        
        return (calender.isDate(date1, inSameDayAs: date2) && (type == "organ"))
    }
    
    // extracting year and month for display
    func extraDate()-> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: getCurrentMonth())
        
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
    
    func checkAppointmentsForDay()-> Bool {
        var thereIs = false
        if (!aptVM.appointments.isEmpty) {
            for index in 0...(aptVM.appointments.count - 1) {
                let apt = aptVM.appointments[index]
                
                if (isSameDay(date1: apt.aptDate, date2: currentDate) && apt.type == "blood" && apt.hospital == Constants.UserInfo.userID) {
                    thereIs = true
                }
            }
        }
        return thereIs
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
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
