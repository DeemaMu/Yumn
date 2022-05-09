import SwiftUI
import Firebase
import FirebaseAuth
import Combine

struct VAppointmentsView: View {
    
    var config = Configuration()
    
    @StateObject var odVM = ODAppointmentVM()
    
    @ObservedObject var aptVM = VAppointments()
    
    
    @State var selectedDate: Date = Date()
    @State var checkedIndex: Int = -1
    @State var showError = false
    
    @Namespace var animation
    
    @State var activate = false
    
    let dateFormatter = DateFormatter()
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    let grey = Color(UIColor.gray)
    
    var thereIS = checkingAppointments()
    
    @State var cancellable:AnyCancellable?
    @State var idCancellable:AnyCancellable?
    
    var calender = Calendar.current
    
    init(config: Configuration){
        self.config = config
        aptVM.currentDay = Date()
        activate = true
    }
    
    //        var appointments: [Appointment] =
    //        [
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 1), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: -2), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        ]
    
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
    
    var vOppStatus: [String:String] =
    [
        "pending": "في الانتظار",
        "accepted": "مقبول",
        "rejected": "مرفوض",
        "DNAttend": "لم يحضر",
        "confirmed": "مؤكد",
        "attended": "حضر",
    ]
    
    var vOppStatusColor: [String:Color] =
    [
        "pending": Color(UIColor.lightGray),
        "accepted": Color.green,
        "rejected": Color.red,
        "DNAttend": Color.red,
        "confirmed": Color.green,
        "attended": Color.green,
    ]
    
    var arOrgan: [String?:String] =
    [
        "kidney":"كلية",
        "liver":"جزء من الكبد",
    ]
    
    var body: some View {
        if #available(iOS 15.0, *){
            
            
            // MARK: current week view
            
            VStack(spacing: 15){
                
                Section{
                    
                    // MARK: current week view
                    ScrollView(.horizontal, showsIndicators: false){
                        ScrollViewReader { value in
                            HStack(spacing: 20){
                                
                                
                                VStack(spacing: 5){
                                    Text("مواعيد").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                    Text("سابقة").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                }
                                .frame(width: 90, height: 90)
                                .background(
                                    // MARK: Mathed gemotry
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    ).fill(mainDark)
                                    //                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                    
                                )
                                .onTapGesture {
                                    var x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.moveToOldApts()
                                }
                                
                                
                                
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
                                            aptVM.filteringAppointments()
                                        }
                                }
                                
                                VStack(spacing: 5){
                                    Text("مواعيد").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                    Text("قادمة").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                }
                                .frame(width: 90, height: 90)
                                .background(
                                    // MARK: Mathed gemotry
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    ).fill(mainDark)
                                )
                                .onTapGesture {
                                    let x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.moveToFutureApts()
                                }
                                
                            }.onAppear(){ // <== Here
                                DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                                    value.scrollTo(6)
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
                                    aptVM.filteringAppointments()
                                })
                            }.onChange(of: activate) { newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                                    value.scrollTo(6)
                                })
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            
                            //                        .environment(\.layoutDirection, .rightToLeft)
                        }
                    }
                    
                    ScrollView(.vertical,  showsIndicators: false){
                        AppointmentsView()
                    }.onChange(of: Constants.selected.deleted) { new in
                        if(Constants.selected.deleted){
                            DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                                aptVM.getUserOA()
                                aptVM.getUserBA()
                                Constants.selected.deleted  = false
                                aptVM.filteringAppointments()
                            })}
                    }
                    
                    Spacer()
                    
                } header: {
                    HeaderView()
                    
                    
                }
                
            }
            .onAppear(){
                activate = true
                odVM.fetchCurrentWeek(weeks: 3)
            }.environment(\.layoutDirection, .rightToLeft)
            //
            
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 10){
            VStack(){
                Text(convertToArabic(date: Date())).font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(.gray)
                
                Text("اليوم").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(lightGray).padding(.top, 7)
                
            }.hLeading()
        }.padding()
            .background(bgWhite)
    }
    
    
    // MARK: Appointments View
    func AppointmentsView() -> some View {
        
        LazyVStack(spacing: 18){
            if let apts = aptVM.filteredAppointments {
                
                if apts.isEmpty {
                    Text("لا توجد مواعيد").font(Font.custom("Tajawal", size: 16))
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
            .padding(.top, 10)
        
    }
    
    //    @available(iOS 15.0, *)
    @ViewBuilder
    func AppoitmentCard(apt: retrievedAppointment, index: Int) -> some View {
        
        if(apt.type == "organ"){
            OrganCard(apt: apt, index: index)
        }
        if(apt.type == "blood"){
            BloodCard(apt: apt, index: index)
        }
        if(apt.type == "volunteering"){
            VOppCard(apt: apt, index: index)
        }
    }
    
    @ViewBuilder
    func OrganCard(apt: retrievedAppointment, index: Int) -> some View {
        
        HStack(){
            
            let today = dateFormatter.string(from: Date())
            let aptDate = dateFormatter.string(from: apt.date!)
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                let title = "موعد فحص مبدئي للتبرع بـ "
                let place = "في "
                
                HStack(){
                    Text(title + self.arOrgan[apt.organ]!).font(Font.custom("Tajawal", size: 17))
                        .foregroundColor(mainDark).padding(.bottom, 10).padding(.top, 10)
                    
                    Spacer()
                    if(today < aptDate){
                        let colorInvert = Color(UIColor.init(named: "mainDark")!.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                                .onTapGesture {
                                    let x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.cancel(apt: apt)
                                }
                            
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                    if(today >= aptDate){
                        let colorInvert = Color(UIColor.gray.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                }
                Text(place + apt.hName!).font(Font.custom("Tajawal", size: 14)).foregroundColor(mainDark)
                
                HStack(){
                    
                    VStack(){
                        ZStack(){
                            Button {
                                
                                self.cancellable = aptVM.getHospitalLocation(apt: apt).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("finished")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }, receiveValue: { location in
                                    if(!location.isEmpty){
                                        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location[0]),\(location[1])&directionsmode=driving")
                                        
                                        if UIApplication.shared.canOpenURL(url!) {
                                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                        } else {
                                            let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(location[0]),\(location[1])&directionsmode=driving")
                                            
                                            UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                                        }
                                    }
                                })
                                
                            } label: {
                                
                                
                                Image("location").resizable()
                                    .scaledToFit()
                                
                            }
                            
                        }
                        
                    }.padding(.top, 10).padding(.bottom, 10)
                    Text(apt.hospitalLocation!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 10).padding(.top, 4).padding(.leading, -5)
                    
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.top, 14).padding(.bottom, 14)
                    
                    Text("\(apt.startTime!.getFormattedDate(format: "HH:mm")) - \(apt.endTime!.getFormattedDate(format: "HH:mm"))").font(Font.custom("Tajawal", size: 12))
                        .foregroundColor(mainDark).padding(.top, 7)
                    
                    Spacer()
                    
                    self.editButton(isFuture: (today < aptDate), apt: apt)
                    
                    
                } .padding(.bottom, 5)
                
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 110)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(height: 110, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 6)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        
    }
    
    @ViewBuilder
    func BloodCard(apt: retrievedAppointment, index: Int) -> some View {
        
        HStack(){
            
            let today = dateFormatter.string(from: Date())
            let aptDate = dateFormatter.string(from: apt.date!)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                let title = "موعد تبرع بالدم"
                let place = "في "
                
                HStack(){
                    Text(title).font(Font.custom("Tajawal", size: 17))
                        .foregroundColor(mainDark).padding(.bottom, 10).padding(.top, 10)
                    Spacer()
                    if(today < aptDate){
                        let colorInvert = Color(UIColor.init(named: "mainDark")!.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                                .onTapGesture {
                                    let x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.cancel(apt: apt)
                                }
                            
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                    if(today >= aptDate){
                        let colorInvert = Color(UIColor.gray.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                }
                Text(place + apt.hName!).font(Font.custom("Tajawal", size: 14)).foregroundColor(mainDark)
                
                HStack(){
                    
                    VStack(){
                        ZStack(){
                            Button {
                                let url = URL(string: "comgooglemaps://?saddr=&daddr=\(apt.lat!),\(apt.long!)&directionsmode=driving")
                                
                                if UIApplication.shared.canOpenURL(url!) {
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                } else {
                                    let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(apt.lat!),\(apt.long!)&directionsmode=driving")
                                    
                                    UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                                }
                            } label: {
                                
                                
                                Image("location").resizable()
                                    .scaledToFit()
                                
                            }
                            
                        }
                        
                    }.padding(.top, 10).padding(.bottom, 10)
                    Text(apt.hospitalLocation!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 10).padding(.top, 4).padding(.leading, -5)
                    
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.top, 14).padding(.bottom, 14)
                    
                    Text("\(apt.startTime!.getFormattedDate(format: "HH:mm")) - \(apt.endTime!.getFormattedDate(format: "HH:mm"))").font(Font.custom("Tajawal", size: 12))
                        .foregroundColor(mainDark).padding(.top, 7)
                    
                    Spacer()
                    
                    self.editButton(isFuture: (today < aptDate), apt: apt)
                    
                    
                } .padding(.bottom, 5)
                
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 110)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(height: 110, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 6)
        .padding(.horizontal, 15)
        .padding(.top, 5)
        
    }
    
    @ViewBuilder
    func VOppCard(apt: retrievedAppointment, index: Int) -> some View {
        
        HStack(){
            
            let today = dateFormatter.string(from: Date())
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                //                let title = "موعد تبرع بالدم"
                HStack(){
                    Text(apt.title!).font(Font.custom("Tajawal", size: 17))
                        .foregroundColor(mainDark).padding(.bottom, 10).padding(.top, 10)
                    Spacer()
                    
                    VStack(){
                        Text(vOppStatus[apt.status!]!).font(Font.custom("Tajawal", size: 12))
                            .foregroundColor(vOppStatusColor[apt.status!]!)
                        
                        
                    }.padding(.top, -20).padding(.bottom, 0)
                    
                    
                }
                
                Text(apt.description!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                
                HStack(){
                    
                    VStack(){
                        ZStack(){
                            Button {
                                
                                self.idCancellable = aptVM.getHospitalID(apt: apt).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("finished")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }, receiveValue: { id in
                                    if(id != ""){
                                        self.cancellable = aptVM.getHospitalLocationById(id: id).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                                            switch completion {
                                            case .finished:
                                                print("finished")
                                            case .failure(let error):
                                                print(error)
                                            }
                                        }, receiveValue: { location in
                                            if(!location.isEmpty){
                                                let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location[0]),\(location[1])&directionsmode=driving")
                                                
                                                if UIApplication.shared.canOpenURL(url!) {
                                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                                } else {
                                                    let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(location[0]),\(location[1])&directionsmode=driving")
                                                    
                                                    UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                                                }
                                            }
                                        })
                                    }
                                })
                                
                            } label: {
                                
                                
                                Image("location").resizable()
                                    .scaledToFit()
                                
                            }
                            
                        }

                    }.padding(.top, 6).padding(.bottom, 6)
                    Text(apt.hospitalLocation!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 15).padding(.top, 4).padding(.leading, -5)
                    
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.top, 10).padding(.bottom, 10)
                    
                    Text("\(apt.timeString!)").font(Font.custom("Tajawal", size: 12))
                        .foregroundColor(mainDark).padding(.top, 7)
                    
                    Spacer()
                    
                    //                    self.editButton(isFuture: (today < aptDate), apt: apt)
                    
                    
                } .padding(.bottom, 5).frame(width: 230, height: 40, alignment: .leading)
                
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 110)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(minHeight: 110, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 6)
        .padding(.horizontal, 15)
        .padding(.top, 5)
        
    }
    
    @ViewBuilder
    func editButton(isFuture: Bool, apt: retrievedAppointment) -> some View {
        if(isFuture){
            Button(action: {
                let x =
                config.hostingController?.parent as! VViewAppointmentsVC
                x.editAppointment(apt: apt)
            }
            ) {
                Text("تعديل").font(Font.custom("Tajawal", size: 14))
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
            .frame(width: 70, height: 30, alignment: .trailing)
        } else {
            Button(action: {
                
            }
            ) {
                Text("تعديل").font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 25,
                    style: .continuous
                )
                    .fill(grey)
            )
            .frame(width: 70, height: 30, alignment: .trailing)
        }
    }
    
    func convertToArabic(date: Date) -> String {
        let formatter = DateFormatter()
        
        //        formatter.dateFormat = "EEEE, d, MMMM, yyyy HH:mm a"
        formatter.dateFormat = "d"
        
        let day = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        
        formatter.dateFormat = "  MMMM, "
        formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        
        let month = formatter.string(from: date)
        
        
        return day + month + year
        
    }
    
    func appointmentsOnDate(date: Date) -> Bool {
        //        var thereIs: Bool = false
        let calender = Calendar.current
        
        for index in 0..<(aptVM.organAppointments.count){
            if(calender.isDate(aptVM.organAppointments[index].date!, inSameDayAs: date)){
                thereIS.thereIs = true
                return true;
            }
        }
        for index in 0..<(aptVM.bloodAppointments.count){
            if(calender.isDate(aptVM.bloodAppointments[index].date!, inSameDayAs: date)){
                thereIS.thereIs = true
                return true;
            }
        }
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let today = dateFormatter.string(from: date)
        
        for i in 0..<(aptVM.volunteeringOpp.count){
            let aptDate = dateFormatter.string(from: aptVM.volunteeringOpp[i].date!)
            let endDate = dateFormatter.string(from:  aptVM.volunteeringOpp[i].endDate!)
            if(aptDate <= today && endDate >= today  ){
                thereIS.thereIs = true
                return true;
                
            }
            
        }
        
        
        return false;
    }
    
}


class VAppointments : ObservableObject {
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    @Published var currentDay: Date = Date()
    @Published var filteredAppointments = [retrievedAppointment]()
    
    @Published var organAppointments = [retrievedAppointment]()
    @Published var bloodAppointments = [retrievedAppointment]()
    @Published var volunteeringOpp = [retrievedAppointment]()
    @Published var olderOA = [retrievedAppointment]()
    @Published var futureOA = [retrievedAppointment]()
    @State var cancellable:AnyCancellable?
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    
    init() {
        organAppointments = self.getUserOA()
        bloodAppointments = self.getUserBA()
        volunteeringOpp = self.getUserVOpp()
        
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        //        olderOA = self.getUserOlderOA()
    }
    
    func getUserBA() -> [retrievedAppointment] {
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        
        db.collection("volunteer").document(userID).collection("bloodAppointments").addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.bloodAppointments = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                
                let duration = 30
                let type = "blood"
                let hName = data["hospitalName"] as! String
                let exact = data["appID"] as! String
                let hospitalId = data["hospitalID"] as! String
                let area = data["area"] as! String
                let city = data["city"] as! String
                let location = city + " - " + area
                let mainDocId = data["mainDocId"] as? String ?? ""
                let latitude:Double = data["latitude"] as? Double ?? 0
                let longitude:Double = data["longitude"] as? Double ?? 0
                
                let stamp1 = data["appDateAndTime"] as? Timestamp
                let startTime = stamp1?.dateValue()
                
                let endTime = Calendar.current.date(byAdding: .minute, value: 30, to: startTime!)
                
                let stamp3 = data["appDateAndTime"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                var apt = retrievedAppointment()
                
                
                apt.duration = duration
                apt.type = type
                apt.date = aptDate
                
                apt.appointmentID = exact
                apt.mainAppointmentID = mainDocId
                apt.endTime = endTime
                
                apt.startTime = startTime
                apt.hospitalID = hospitalId
                apt.hName = hName
                apt.hospitalLocation = location
                
                apt.lat = latitude
                apt.long = longitude
                
                return apt
                
            }
            
        }
        
        return self.bloodAppointments
    }
    
    func getUserVOpp() -> [retrievedAppointment] {
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        
        db.collection("volunteer").document(userID).collection("volunteeringOpps").addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.volunteeringOpp = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                
                let type = "volunteering"
                let mainDoc = data["mainDocId"] as! String
                //                let hospitalId = data["hospitalId"] as! String
                let location = data["location"] as! String
                let status = data["status"] as! String
                let title = data["title"] as! String
                let description = data["description"] as! String
                
                //                var tempDate: String = ""
                //                var tempTime: String = ""
                //                // convert dates
                //                DispatchQueue.main.async {
                //
                let tempTime = data["workingHours"] as! String
                
                
                //                let i = tempDate.firstIndex(of: "-")
                //                tempDate.remove(at: i)
                //                tempDate = tempDate.replacingOccurrences(of: "/", with: "-")
                //                let dates = tempDate.split(separator: " ")
                //
                //
                //                let endDate = dates[1].description.toDate(.isoDate)
                //                let startDate = dates[0].description.toDate(.isoDate)
                //
                //                 // extract time
                //                let j = tempTime.firstIndex(of: "-")
                //                tempTime.remove(at: j!)
                //                tempTime = tempTime.replacingOccurrences(of: "/", with: "-")
                //                let times = tempTime.split(separator: " ")
                //
                //                let startTime = String(times[1])
                //                let endTime = String(times[0])
                
                let stamp1 = data["start_date"] as? Timestamp
                let startTime = stamp1?.dateValue()
                
                let stamp2 = data["end_date"] as? Timestamp
                let endTime = stamp2?.dateValue()
                
                var apt = retrievedAppointment()
                
                
                apt.type = type
                apt.status = status
                apt.title = title
                apt.description = description
                apt.timeString = tempTime
                apt.endDate = endTime
                apt.date = startTime
                
                apt.mainAppointmentID = mainDoc
                
                apt.hospitalLocation = location
            
                
                return apt
                
            }
            
            DispatchQueue.main.async {
                for i in 0..<self.volunteeringOpp.count {
                    self.volunteeringOpp[i].hName = self.getHospitalName(apt: self.volunteeringOpp[i])
                }
            }
            
        }
        
        return self.volunteeringOpp
    }
    
    func getUserOA() -> [retrievedAppointment] {
        olderOA.removeAll()
        futureOA.removeAll()
        
        //        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        //        self.dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let past = (Date() - 7).getFormattedDate(format: "yyyy/MM/dd")
        let future = (Date() + 7).getFormattedDate(format: "yyyy/MM/dd")
        
        db.collection("volunteer").document(userID).collection("organAppointments").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.organAppointments = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                
                let duration = data["appointment_duration"] as! Int
                let type = data["type"] as? String ?? ""
                let hName = data["hospital_name"] as! String
                let exact = data["docID"] as! String
                let mainDoc = data["mainDocId"] as? String  ?? ""
                let hospitalId = data["hospital"] as! String
                let location = data["location"] as? String ?? ""
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1?.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2?.dateValue()
                
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                var apt = retrievedAppointment()
                
                if(type == "organ"){
                    let organ = data["organ"] as! String
                    apt.organ = organ
                }
                
                apt.duration = duration
                apt.type = type
                apt.date = aptDate
                
                apt.appointmentID = exact
                apt.mainAppointmentID = mainDoc
                apt.endTime = endTime
                
                apt.startTime = startTime
                apt.hospitalID = hospitalId
                apt.hName = hName
                apt.hospitalLocation = location
                
                return apt
                
            }
            
            for appointment in self.organAppointments {
                let ogDate = appointment.date!.getFormattedDate(format: "yyyy/MM/dd")
                print(ogDate)
                
                if(future < ogDate){
                    self.futureOA.append(appointment)
                }
                
                if(past > ogDate){
                    self.olderOA.append(appointment)
                }
            }
            
        }
        
        
        return self.organAppointments
    }
    
    
    func filteringAppointments() -> [retrievedAppointment] {
        let calender = Calendar.current
        var filtered = [retrievedAppointment]()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if(!self.organAppointments.isEmpty){
                
                filtered = self.organAppointments.filter {
                    return calender.isDate($0.date!, inSameDayAs: self.currentDay)
                }
                
            }
            
            if(!self.bloodAppointments.isEmpty){
                
                filtered.append(contentsOf:
                                    self.bloodAppointments.filter {
                    return calender.isDate($0.date!, inSameDayAs: self.currentDay)
                })
                
            }
            
            if(!self.volunteeringOpp.isEmpty){
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.dateFormatter.locale = Locale(identifier:"en_US_POSIX")
                let today = self.dateFormatter.string(from: self.currentDay)
                
                for i in 0..<self.volunteeringOpp.count {
                    let aptDate = self.dateFormatter.string(from: self.volunteeringOpp[i].date!)
                    let endDate = self.dateFormatter.string(from:  self.volunteeringOpp[i].endDate!)
                    print(aptDate)
                    print(today)
                    if(aptDate <= today && endDate >= today  ){
                        filtered.append( self.volunteeringOpp[i])
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredAppointments = filtered
                }
            }
            
            
        }
        
        return self.filteredAppointments
    }
    
    
    func getCurrentDate(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var currentDate = ""
        if(time == "past"){
            currentDate = dateFormatter.string(from: Date() - 7)
        }
        if(time == "future"){
            currentDate = dateFormatter.string(from: Date() + 7)
        }
        print("current date is \(currentDate)")
        return currentDate
        
    }
    
    func getHospitalName(apt: retrievedAppointment) -> String {
        var name = ""
        let doc = db.collection("volunteeringOpp").document(apt.mainAppointmentID!)
        
        doc.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            print("here")
            let dataDescription = document.data()
            name = dataDescription?["hospitalName"] as! String
        }
        
        return name
    }
    
    func getHospitalID(apt: retrievedAppointment) -> Future<String, Error> {
        var id = ""
        
        return Future<String, Error> { promise in
            DispatchQueue.main.async {
                
                let doc = self.db.collection("volunteeringOpp").document(apt.mainAppointmentID!)
                
                doc.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        print("Document does not exist")
                        promise(.failure(error!))
                        return
                    }
                    print("here")
                    let dataDescription = document.data()
                    id = dataDescription?["posted_by"] as? String ?? ""
                    promise(.success(id))
                }
            }
        }
        
    }
    
    func getHospitalLocation(apt: retrievedAppointment) -> Future<[Double], Error> {
        
        return Future<[Double], Error> { promise in
            DispatchQueue.main.async {
                
                let doc = self.db.collection("hospitalsInformation").document(apt.hospitalID!)
                
                doc.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        print("Document does not exist")
                        promise(.failure(error!))
                        return
                    }
                    print("got them")
                    let dataDescription = document.data()
                    let latitude:Double = dataDescription?["latitude"] as? Double ?? 0
                    let longitude:Double = dataDescription?["longitude"] as? Double ?? 0
                    promise(.success([latitude, longitude]))
                }
            }
        }
        
    }
    
    func getHospitalLocationById(id: String) -> Future<[Double], Error> {
        
        return Future<[Double], Error> { promise in
            DispatchQueue.main.async {
                
                let doc = self.db.collection("hospitalsInformation").document(id)
                
                doc.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        print("Document does not exist")
                        promise(.failure(error!))
                        return
                    }
                    print("got them")
                    let dataDescription = document.data()
                    let latitude:Double = dataDescription?["latitude"] as? Double ?? 0
                    let longitude:Double = dataDescription?["longitude"] as? Double ?? 0
                    promise(.success([latitude, longitude]))
                }
            }
        }
        
    }

    
}

struct VAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        VAppointmentsView(config: Configuration())
    }
}

func checkTimeStampOlder(date: String!) -> Bool {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    let datecomponents = dateFormatter.date(from: date)
    
    let now = Date() - 7
    
    if (now >= datecomponents!) {
        return true
    } else {
        return false
    }
}

extension UIColor {
    var inverted: UIColor {
        var a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? UIColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a) : .black
    }
}
