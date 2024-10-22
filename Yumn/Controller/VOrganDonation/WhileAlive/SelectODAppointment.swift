//
//  SelectODAppointment.swift
//  Yumn
//
//  Created by Rawan Mohammed on 26/04/2022.
//

import SwiftUI
import Firebase

struct SelectODAppointment: View {
    let config: Configuration
    
    @ObservedObject var aptVM = AppointmentVM()
    @StateObject var odVM = ODAppointmentVM()
    
    var thereIS = checkingAppointments()
    
    @State var selectedDate: Date
    @State var checkedIndex: Int = -1
    @State var showError = false
    @State var empty = true
    var counter = 0
    
    @State var selectedAppointment:OrganAppointment?
    @State var selectedMiniAppointment: DAppointment?
    
    
    @State var thisDayApt: [OrganAppointment] = [OrganAppointment]()
    @Namespace var animation
    
    @State var activate = false
    
    var calender = Calendar.current
    
    var hospitalID = Constants.selected.selectedOrgan.hospital
    var selectedOrgan = Constants.selected.selectedOrgan.organ
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    
    //    var appointments: [Appointment] =
    //    [
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 1), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        OrganAppointment(appointments:
    //                            [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                         , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 3), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //    ]
    
    var weekdaysAR: [String:String] =
    [
        "Sun": "الأحد",
        "Mon": "الأثنين",
        "Tue": "الثلاثاء",
        "Wed": "الاربعاء",
        "Thu":"الخميس",
        "Fri":"الجمعة",
        "Sat":"السبت"
    ]
    
    
    var body: some View {
        
        
        VStack(spacing: 15){
            
            HeaderView()
            // MARK: current week view
            ScrollView(.horizontal, showsIndicators: false){
                ScrollViewReader { value in
                    HStack(spacing: 20){
                        // MARK: Display dates
                        ForEach(0..<odVM.currentWeek.count, id: \.self){ day in
                            VStack(spacing: 5){
                                Text(odVM.extractDate(date: odVM.currentWeek[day], format: "dd")).font(Font.custom("Tajawal", size: 25))
                                    .foregroundColor(odVM.isToday(date: odVM.currentWeek[day]) ? .white : mainDark).fontWeight(.semibold)
                                
                                // MARK: Returns days
                                Text(weekdaysAR[odVM.extractDate(date: odVM.currentWeek[day], format: "EEE")]!).font(Font.custom("Tajawal", size: 14))
                                    .foregroundColor(odVM.isToday(date: odVM.currentWeek[day]) ? .white : mainDark)
                                //                                            .foregroundColor(self.organsVM.selected[organ]! ? .white : mainDark)
                                
                                // MARK: circle under
                                ZStack{
                                    Circle().fill(appointmentsOnDate(date: odVM.currentWeek[day]) ? mainDark : .white)
                                        .frame(width: 8, height: 8)
                                        .opacity(appointmentsOnDate(date: odVM.currentWeek[day]) ? 1 : 0)
                                    
                                    if(calender.isDate( odVM.currentWeek[day], inSameDayAs: selectedDate)){
                                        Circle().fill(.white)
                                            .frame(width: 8, height: 8)
                                            .opacity(appointmentsOnDate(date: odVM.currentWeek[day]) ? 1 : 0)
                                    }
                                    
                                }
                                
                            }.id(day)
                            //                                        .foregroundStyle(odVM.isToday(date: odVM.currentWeek[day]) ? .primary : .tertiary)
                                .frame(width: 90, height: 90)
                                .background(
                                    ZStack{
                                        // MARK: Mathed gemotry
                                        if(odVM.isToday(date: odVM.currentWeek[day])){
                                            RoundedRectangle(
                                                cornerRadius: 10,
                                                style: .continuous
                                            ).fill(mainDark)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        } else {
                                            RoundedRectangle(
                                                cornerRadius: 10,
                                                style: .continuous
                                            ).fill(bgWhite)
                                        }
                                        //                                                    .fill(self.organsVM.selected[organ]! ? mainDark : .white)
                                    }
                                )
                                .shadow(color: shadowColor,
                                        radius:  odVM.isToday(date: odVM.currentWeek[day]) ? 0 : 3, x: 0
                                        , y:  odVM.isToday(date: odVM.currentWeek[day]) ? 0 : 6)
                                .onTapGesture {
                                    // updating current date
                                    selectedDate = odVM.currentWeek[day]
                                    withAnimation {
                                        odVM.currentDay = odVM.currentWeek[day]
                                    }
                                }.onChange(of: selectedDate) { newValue in
                                    aptVM.currentDay = newValue
                                    checkedIndex = -1
                                    DispatchQueue.main.async {
                                        aptVM.filteringAppointments()
                                    }
                                    
                                }
                        }
                    }.onAppear(){ // <== Here
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            value.scrollTo(0)
                            aptVM.filteringAppointments()
                        })
                    }.onChange(of: activate) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            value.scrollTo(0)
                        })
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    //                        .environment(\.layoutDirection, .rightToLeft)
                }
            }.onAppear {
                aptVM.filteringAppointments()
            }
            
            Section{
                
                ScrollView(.vertical,  showsIndicators: false){
                    AppointmentsView()
                }.padding()
                
            }
            
            Spacer()
            
            if(showError && !aptVM.organAppointments.isEmpty){
                if(!aptVM.organAppointments.isEmpty){
                    Text("الرجاء اختيار موعد للمتابعة").font(Font.custom("Tajawal", size: 15))
                        .foregroundColor(.red)
                    
                }
            }
            
            if(aptVM.organAppointments.isEmpty || !thereIS.thereIs){
                Text("عذرًا، لايوجد مواعيد للمستشفى المختار").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(.red)
            }
            
            Button(action: {
                if(checkedIndex == -1){
                    showError = true
                } else {
                    showError = false
                    let x =
                    config.hostingController?.parent as! Alive4thVC
                    x.confirmAppoitment(apt: selectedAppointment!, exact: selectedAppointment!.appointments![0])
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute: {
                    //                        if(odVM.checkIfFree2(doc: selectedAppointment!, exactID: selectedMiniAppointment!.docID)){
                    //                            showError = false
                    //                            let x =
                    //                            config.hostingController?.parent as! Alive4thVC
                    //                            x.confirmAppoitment(apt: selectedAppointment!, exact: selectedMiniAppointment!)
                    //                        }
                    //                        else {
                    //                            print("cant")
                    //                        }
                    //                    })
                    
                    
                }
            }
            ) {
                Text("تأكيد").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 25,
                    style: .continuous
                )
                    .fill(mainDark)
            )
            .frame(width: 230, height: 59, alignment: .center)
            
            
        }.onAppear() {
            activate = true
            odVM.fetchCurrentWeek(weeks: 2)
            aptVM.filteringAppointments()
        }.environment(\.layoutDirection, .rightToLeft)
        
        
    }
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 10){
            VStack(){
                
                Text("التاريخ").font(Font.custom("Tajawal", size: 16)).fontWeight(.bold)
                    .foregroundColor(mainDark)
                
            }.hLeading()
        }.background(bgWhite)
    }
    
    
    // MARK: Appointments View
    func AppointmentsView() -> some View {
        ZStack(){
            if(empty){
                Text("لايوجد مواعيد متاحة لهذا التاريخ").font(Font.custom("Tajawal", size: 16))
                    .foregroundColor(lightGray).padding(.top, 100).multilineTextAlignment(.center)
            }
            
                LazyVStack(spacing: 20){
                    if let apts = aptVM.filteredAppointments {
                        
                        if apts.isEmpty {
                            Text("لايوجد مواعيد متاحة لهذا التاريخ").font(Font.custom("Tajawal", size: 16))
                                .foregroundColor(lightGray).padding(.top, 100).multilineTextAlignment(.center)
                            
                        } else {
                            ForEach(0..<apts.count, id: \.self){ index in
                                AppoitmentCard(apt: apts[index], index: index)
                            }
                        }
                        
                    } else {
                        //MARK: Progress view
                        ProgressView()
                            .offset(y: 100).foregroundColor(mainDark)
                    }
                }.frame(maxHeight: .infinity)
                .onDisappear {
                    empty = true
                }
                
            }
    }
    
    @ViewBuilder
    func AppoitmentCard(apt: OrganAppointment, index: Int) -> some View {
        
        let mini = aptVM.fetchAppointmentsData2(docID: apt.docID)
        
        if(!mini.isEmpty){
            
            let currentA = mini[apt.docID]
            if(currentA != nil){
            if(odVM.checkIfFree(doc: apt, exactID: currentA![0].docID)) {
                
                HStack(){
                    VStack(alignment: .leading){
                        if(self.checkedIndex == index){
                            RadioButton2(matched: true)
                        }
                        if(self.checkedIndex != index){
                            RadioButton2(matched: false)
                        }
                    }.padding(.leading, 20)
                        .padding(.top, 3)
                        .onAppear{
                            empty = false
                        }
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        Text("\(aptVM.filteredAppointments[index].startTime.getFormattedDate(format: "HH:mm")) - \(aptVM.filteredAppointments[index].endTime.getFormattedDate(format: "HH:mm"))").font(Font.custom("Tajawal", size: 22))
                            .foregroundColor(mainDark)
                    }.frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 50)
                        .padding(.top, 10)
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.trailing, 10).padding(.top, 10).padding(.bottom, 10)
                    
                    
                    
                    
                    
                }.onChange(of: checkedIndex){ newValue in
                    if(newValue == index){
                        DispatchQueue.main.async {
                            aptVM.filteredAppointments[index].appointments = mini[apt.docID]
                            
                        }
                        
                        
                    } else {
                    }
                }
                .environment(\.layoutDirection, .leftToRight)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                        .fill(.white)
                )
                .frame(height: 50, alignment: .center)
                .frame(maxWidth: 250)
                .shadow(color: shadowColor,
                        radius: 6, x: 0
                        , y: 6)
                .onTapGesture {
                    if(checkedIndex == index){
                        checkedIndex = -1
                        showError = true
                    } else {
                        
                        //                        DispatchQueue.main.async {
                        //                            apt.appointments?.append(                        aptVM.fetchAppointmentsData2(docID: apt.docID)[0]
                        //                        )}
                        //                        selectedMiniAppointment = apt.appointments?.first
                        selectedAppointment = aptVM.filteredAppointments[index]
                        checkedIndex = index
                        showError = false
                        
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                
                
                
            }
            }
        } else {

        }
        
    }
    
    func appointmentsOnDate(date: Date) -> Bool {
        let calender = Calendar.current
        
        for index in 0..<(aptVM.organAppointments.count){
            if((calender.isDate(aptVM.organAppointments[index].aptDate, inSameDayAs: date))
               && (aptVM.organAppointments[index].bookedAppointments?.isEmpty)!){
                thereIS.thereIs = true
                return true;
            }
        }
        return false;
    }
    
    
}

struct SelectODAppointment_Previews: PreviewProvider {
    static var previews: some View {
        SelectODAppointment(config: Configuration(), selectedDate: Date())
    }
}

extension View{
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}


class ODAppointmentVM: ObservableObject {
    @Published var currentWeek: [Date] = []
    
    // MARK: Curent day
    @Published var currentDay: Date = Date()
    let db = Firestore.firestore()
    
    func fetchCurrentWeek(weeks: Int){
        let today = Date() - 7
        let calender = Calendar.current
        
        let week = calender.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        //        let firstWeekDay2 =  firstWeekDay.
        
        if(weeks == 2){
            (0...14).forEach {
                day in
                
                //            if let weekday = calender.date(byAdding: .day, value: day, to: (firstWeekDay - 1)) {
                //                currentWeek.append(weekday)
                //            }
                
                if let weekday = calender.date(byAdding: .day, value: day, to: currentDay) {
                    currentWeek.append(weekday)
                }
                
            }
        }
        
        var i = -7;
        
        if(weeks == 3){
            (0...6).forEach {
                day in
                
                //            if let weekday = calender.date(byAdding: .day, value: day, to: (firstWeekDay - 1)) {
                //                currentWeek.append(weekday)
                //            }
                
                if let weekday = calender.date(byAdding: .day, value:  i, to: currentDay) {
                    currentWeek.append(weekday)
                }
                
                i += 1
            }
            
            (0...7).forEach {
                day in
                
                //            if let weekday = calender.date(byAdding: .day, value: day, to: (firstWeekDay - 1)) {
                //                currentWeek.append(weekday)
                //            }
                
                if let weekday = calender.date(byAdding: .day, value: day, to: currentDay) {
                    currentWeek.append(weekday)
                }
                
            }
        }
    }
    
    
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calender = Calendar.current
        
        return calender.isDate(currentDay, inSameDayAs: date)
    }
    
    
    func checkIfFree(doc: OrganAppointment, exactID: String) -> Bool {
        var free = false
        if(doc.bookedAppointments!.isEmpty){
            free = true
        } else {
            if(doc.bookedAppointments!.contains(exactID)){
                free = false
            }
        }
        
        return free
    }
    
    
}

class checkingAppointments{
    var thereIs = false
}
