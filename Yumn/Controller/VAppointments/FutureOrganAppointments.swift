//
//  FutureOrganAppointments.swift
//  Yumn
//
//  Created by Rawan Mohammed on 29/04/2022.
//

import SwiftUI

struct FutureOrganAppointments: View {
    var config = Configuration()
    
    @StateObject var odVM = ODAppointmentVM()
    
    @ObservedObject var aptVM = VAppointments()
    
    
    @State var selectedDate: Date = Date()
    
    @Namespace var animation
    
    
    @State var activate = false
    
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    var calender = Calendar.current
    
    init(config: Configuration){
        self.config = config
        aptVM.currentDay = Date()
        activate = true
    }
    
    
    var arOrgan: [String?:String] =
    [
        "kidney":"كلية",
        "liver":"جزء من الكبد",
    ]
    
    var body: some View {
        
        
        
        // MARK: current week view
        
        VStack(spacing: 15){
            
            Section{
                
                // MARK: current week view
                ScrollView(.vertical,  showsIndicators: false){
                    AppointmentsView()
                }
                
                Spacer()
                
            }
            
        }
        .onAppear(){
            activate = true
            odVM.fetchCurrentWeek(weeks: 3)
            //            aptVM.getUserOA()
        }.environment(\.layoutDirection, .rightToLeft)
        //
        
        
    }
    
    // MARK: Appointments View
    func AppointmentsView() -> some View {
        
        LazyVStack(spacing: 18){
            if let apts = aptVM.futureOA {
                
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
            .padding(.top, 20)
        
    }
    
    //    @available(iOS 15.0, *)
    @ViewBuilder
    func AppoitmentCard(apt: retrievedAppointment, index: Int) -> some View {
        HStack(){
            Spacer()
            
            VStack(alignment: .leading, spacing: 0){
                let title = "موعد فحص مبدئي للتبرع بـ "
                let place = "في "
                HStack(){
                    
                    
                    Text(title + self.arOrgan[apt.organ]!).font(Font.custom("Tajawal", size: 17))
                        .foregroundColor(mainDark).padding(.bottom, 10).padding(.top, 15)
                    
                    Spacer()
                    
                    let colorInvert = Color(UIColor.init(named: "mainDark")!.inverted)
                    VStack(){
                        Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                            .scaledToFit().font(.system(size: 17).bold())
                            .onTapGesture {
                                
                            }.padding(.trailing, 20)
                        
                    }.padding(.top, 0).padding(.bottom, 0)
                }
                
                Text(place + apt.hName!).font(Font.custom("Tajawal", size: 14)).foregroundColor(mainDark)
                
                Spacer()
                
                HStack(){
                    VStack(){
                        Image("appCalendar").resizable()
                            .scaledToFit()
                    }.padding(.bottom,9).padding(.top, 9)
                    Text(apt.date!.getFormattedDate(format: "yyyy/MM/dd")).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 40).padding(.top, 5)
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.bottom, 9).padding(.top, 9)
                    
                    Text("\(apt.startTime!.getFormattedDate(format: "HH:mm")) - \(apt.endTime!.getFormattedDate(format: "HH:mm"))").font(Font.custom("Tajawal", size: 12))
                        .foregroundColor(mainDark).padding(.top, 5)
                }
                
                HStack(){
                    
                    VStack(){
                        Image("location").resizable()
                            .scaledToFit()
                    }.padding(.bottom, 2).padding(.top, 2)
                    Text(apt.hospitalLocation!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 10).padding(.leading, -3)
                    
                    Spacer()
                    
                    self.editButton()
                    
                } .padding(.bottom, 5).padding(.leading, -3)
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 130)
                .shadow(color: shadowColor,
                        radius: 0, x: 0
                        , y: 0)
            //                .padding(5)
            
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(height: 130, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 0)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        
        
    }
    
    @ViewBuilder
    func editButton() -> some View {
        Button(action: {
            let x =
            config.hostingController?.parent as! VViewAppointmentsVC
        }
        ) {
            Text("تعديل").font(Font.custom("Tajawal", size: 16))
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
        .padding(.trailing, 20)
        .padding(.bottom, 10)
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
}

struct FutureOrganAppointments_Previews: PreviewProvider {
    static var previews: some View {
        FutureOrganAppointments(config: Configuration())
    }
}
