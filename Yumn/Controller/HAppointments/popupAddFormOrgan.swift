//
//  PopupAddForm.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/03/2022.
//

import SwiftUI
import UIKit
import Combine

struct PopupAddFormOrgan: View {
    var controller: ManageAppointmentsViewController = ManageAppointmentsViewController()
    
    @State var date: Date = Constants.selected.selectedDate
    // colors
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let redC = Color(UIColor.red)
    let newWhite: Color = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    
    // dropdown variables
    
    @State var apptTypeText = ""
    @State var apptType = ""
    var placeholder = "اختر العضو"
    var dropDownList = ["تبرع بكلية", "تبرع بجزء من الكبد"]
    
    
    @State var selectedDate: Date = Constants.selected.selectedDate
    
    @State var typeText = ""
    
    @State var endDateTxt = Constants.selected.selectedDate.addingTimeInterval(60 * 60).getFormattedDate(format: "HH:mm")
    @State var endDate: Date = Constants.selected.selectedDate.addingTimeInterval(60 * 60)
    
    @State var durationValue: Double = 0
    
    @ObservedObject var aptVM = AppointmentVM()
    
    
    init(controller: ManageAppointmentsViewController, date: Date){
        self.date = date
        self.controller = controller
        self.selectedDate = date
        self.endDate = date
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack(alignment: .topLeading){
                
                VStack(alignment: .leading){
                    Button(action: {
                        controller.hideOverlay()
                    }) {
                        Text("x").font(Font.custom("Tajawal", size: 30))
                            .foregroundColor(lightGray)
                    }
                    
                    
                }.padding(.leading, 20)
                
                Text("إضافة موعد فحص مبدئي").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(mainDark)
                    .frame(maxWidth: .infinity)
                //                    .padding(.leading, -25)
                
                
            }.frame(maxWidth: .infinity)
            
            
            Form(){
                
                
                
                if #available(iOS 15.0, *) {
                    
                    VStack(alignment: .trailing, spacing: 20){
                        createLabel(label: "وقت بداية الموعد:")
                        DatePicker("",
                                   selection: $selectedDate, displayedComponents: [.hourAndMinute])
                            .accentColor(.white)
                            .background(mainDark.colorInvert())
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .preferredColorScheme(.light)
                            .colorInvert()
                            .labelsHidden()
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(maxWidth: .infinity)
                        
                        
                    }.listRowSeparator(.hidden)
                    
                    
                    HStack(alignment: .center){
                        TextField("", text: $endDateTxt)
                            .disabled(true)
                            .font(Font.custom("Tajawal", size: 17))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                        //                        .underlineTextField()
                            .onChange(of: selectedDate){newValue in
                                endDate = newValue.addingTimeInterval(1 * 60 * 60)
                                endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                            }
                        
                        createLabel(label: "ينتهي الموعد:")
                        
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .listRowSeparator(.hidden)
                    
                    VStack(alignment: .trailing, spacing: 20){
                        createLabel(label: "موعد فحص مبدئي لـ")
                        
                        Menu {
                            ForEach(dropDownList, id: \.self){ client in
                                Button(client) {
                                    self.apptTypeText = client
                                }.multilineTextAlignment(.trailing)
                            }
                            .onChange(of: apptTypeText){newValue in
                                if(!newValue.isEmpty){
                                    switch newValue{
                                    case dropDownList[0]:
                                        self.apptType = "kidney"
                                        break
                                    case dropDownList[1]:
                                        self.apptType = "liver"
                                        break
                                    default:
                                        self.apptType = "none"
                                    }
                                }
                            }
                            
                        } label: {
                            VStack(spacing: 5){
                                HStack{
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(mainDark)
                                        .font(Font.system(size: 20, weight: .bold))
                                    Spacer()
                                    Text(apptTypeText.isEmpty ? placeholder : apptTypeText)
                                        .foregroundColor(typeText.isEmpty ? .gray : .black).font(Font.custom("Tajawal", size: 15))
                                }
                                .padding(.horizontal)
                                Rectangle()
                                    .fill(mainDark)
                                    .frame(height: 1)
                                    .padding(.top, 8)
                                    .padding(.horizontal , 10)
                            }
                        }
                        
                        
                    }.frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .padding(.bottom, 30)
                    
                    
                    HStack(alignment: .center){
                        Button(action: {
                            saveData()
                        }) {
                            Text("إضافة").font(Font.custom("Tajawal", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 75)
                                .padding(.vertical, 10)
                            
                        }
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                                .fill(buttonColor())
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                } else {
                    
                }
                
            }.padding(0)
                .background(Color.white)
            
        }.onAppear(){
            
            UIDatePicker.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .white
            
        }.onDisappear(){
            UIDatePicker.appearance().backgroundColor = .systemGroupedBackground
            UITableView.appearance().backgroundColor = .systemGroupedBackground
        }
        
        
    }
    
    
    func createLabel(label: String)-> Text {
        return Text(label).font(Font.custom("Tajawal", size: 17)).foregroundColor(mainDark)
    }
    
    func buttonColor()-> Color {
        if (!apptTypeText.isEmpty){
            return mainDark
        } else {
            return .gray
        }
    }
    
    func saveData() {
        print("hereeeee1111")
        let duration = 60.0
        let apList = createAppointmentList()
        
        let apt = OrganAppointment(type: "organ",
                                   startTime: selectedDate, endTime: selectedDate.addingTimeInterval(60 * 60),
                                   aptDate: date, hospital: Constants.UserInfo.userID, aptDuration: duration, organ: apptType)
        
        apt.appointments = apList
        apt.bookedAppointments = [String]()
        aptVM.addDataOrgan(apt: apt)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            if(aptVM.added){
                self.controller.showSuccessPopUp()
            }
            else {
                self.controller.showFailPopUp()
            }
        })
    }
    
    func createAppointmentList() -> [DAppointment] {
        
        print("hereeeee222222")
        var list = [DAppointment]()
        
        let currentDate = selectedDate
        
        let currentEnd = currentDate.addingTimeInterval(60 * 60)
        
        list.append(DAppointment(type: "organ", startTime: currentDate, endTime: currentEnd, donor: "", hName: Constants.UserInfo.userID, confirmed: "", booked: false))
        
        
        print("\(list.count)")
        return list
        
    }
    
}

struct PopupAddFormOrgan_Previews: PreviewProvider {
    static var previews: some View {
        PopupAddFormOrgan(controller: ManageAppointmentsViewController(), date: Date())
    }
}




