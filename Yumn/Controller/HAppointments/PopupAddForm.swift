//
//  PopupAddForm.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/03/2022.
//

import SwiftUI
import UIKit
import Combine


struct PopupAddForm: View {
    
    var controller: ManageAppointmentsViewController = ManageAppointmentsViewController()
    
    @State var date: Date = Constants.selected.selectedDate

    
    // colors
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let redC = Color(UIColor.red)
    let newWhite: Color = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    
    // dropdown variables
    
    @State var durationPerAText = ""
    @State var durationPerA: Double = 0
    var placeholder = "اختر مدة الموعد"
    var dropDownList = ["15 دقيقة", "30 دقيقة", "1 ساعة"]
    
    
    @State var selectedDate: Date = Constants.selected.selectedDate
    
    @State var durationText = ""
    @State var duration: Int = 0
    @State var durationError = ""
    @State var isDurationValid = false
    
    
    @State var endDateTxt = Constants.selected.selectedDate.getFormattedDate(format: "HH:mm")
    @State var endDate: Date = Constants.selected.selectedDate
    
    
    @State var peoplePerAText = ""
    @State var peoplePerA: Int = 0
    @State var pplPerAError = ""
    @State var isPplNValid = false
    @State var underlineColor2: Color = Color(UIColor.init(named: "mainDark")!)
    
    @State var durationValue: Double = 0
    
    @State var underlineColor: Color = Color(UIColor.init(named: "mainDark")!)
    
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
                
                Text("إضافة فترة مواعيد").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(mainDark)
                    .frame(maxWidth: .infinity)
                //                    .padding(.leading, -25)
                
                
            }.frame(maxWidth: .infinity)
            
            
            Form(){
                
                
                
                if #available(iOS 15.0, *) {
                    
                    VStack(alignment: .trailing, spacing: 20){
                        createLabel(label: "وقت بداية فترة المواعيد")
                        
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
                    
                    
                    
                    VStack(alignment: .trailing, spacing: 5){
                        
                        createLabel(label: "مدة فترة المواعيد")
                        
                        HStack(){
                            Spacer()
                            ZStack(){
                                HStack(){
                                    Text("ساعة").font(Font.custom("Tajawal", size: 17)).foregroundColor(underlineColor).multilineTextAlignment(.leading)
                                    Spacer()
                                    
                                }
                                
                                
                                TextField("", text: $durationText)
                                    .placeholder(when: durationText.isEmpty){
                                        Text("المدة").font(Font.custom("Tajawal", size: 15)).foregroundColor(lightGray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.trailing)
                                    .underlineTextField(color: $underlineColor)
                                    .keyboardType(.numberPad)
                                    .onChange(of: durationText){newValue in
                                        if(newValue.isEmpty || newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
                                            self.underlineColor = Color.red
                                            self.durationError = "أدخل قيمة عددية مقبولة"
                                            self.isDurationValid = false
                                            duration = 0
                                        }
                                        if(!newValue.isEmpty){
                                            if(!newValue.trimmingCharacters(in: .letters).isEmpty &&
                                               !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newValue.trimmingCharacters(in: .symbols).isEmpty){
                                                if(Int(newValue)! > 24 || Int(newValue)! <= 0){
                                                    duration = 0
                                                    self.underlineColor = Color.red
                                                    self.durationError = "أدخل قيمة عددية مقبولة"
                                                    self.isDurationValid = false
                                                }
                                                else {
                                                    self.isDurationValid = true
                                                    self.durationError = ""
                                                    self.duration = Int(newValue)!
                                                    self.underlineColor = Color(UIColor.init(named: "mainDark")!)
                                                }
                                            }
                                            else {
                                                duration = 0
                                                self.underlineColor = Color.red
                                                self.durationError = "أدخل قيمة عددية مقبولة"
                                                self.isDurationValid = false
                                            }
                                        }
                                    }
                            }
                        }
                        
                        TextField("", text: $durationError).font(Font.custom("Tajawal", size: 13)).foregroundColor(.red)
                            .disabled(true).multilineTextAlignment(.trailing)
                            .padding(.trailing, 10)
                            .fixedSize(horizontal: false, vertical: true)
                        
                    }.listRowSeparator(.hidden)
                        .padding(.top, 20)
                    
                    
                    
                    HStack(alignment: .center){
                        TextField("", text: $endDateTxt)
                            .disabled(true)
                            .font(Font.custom("Tajawal", size: 17))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: durationText){newValue in
                                if(newValue.isEmpty || newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
                                    self.durationValue = 0
                                    endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                    endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                }
                                if(!newValue.isEmpty){
                                    if(!newValue.trimmingCharacters(in: .letters).isEmpty &&
                                       !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newValue.trimmingCharacters(in: .symbols).isEmpty) {
                                        if(Int(newValue)! > 24 || Int(newValue)! <= 0){
                                            self.durationValue = 0
                                            endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                            endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                        }
                                        else {
                                            self.durationValue = Double(newValue)!
                                            endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                            endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                        }
                                    }
                                    else {
                                        self.durationValue = 0
                                        endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                        endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                    }
                                    
                                } else {
                                    self.durationValue = 0
                                    endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                    endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                }
                            }
                            .onChange(of: selectedDate){newValue in
                                endDate = newValue.addingTimeInterval(durationValue * 60 * 60)
                                endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                            }
                        
                        createLabel(label: "تنتهي الفترة:")
                        
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.bottom, 30)
                        .padding(.top, 10)
                        .listRowSeparator(.hidden)
                    
                    
                    VStack(alignment: .trailing, spacing: 5){
                        
                        createLabel(label: "عدد المواعيد لكل 30 دقيقة")
                        
                        TextField("", text: $peoplePerAText)
                            .placeholder(when: peoplePerAText.isEmpty){
                                Text("عدد المواعيد").font(Font.custom("Tajawal", size: 15)).foregroundColor(lightGray)
                            }
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                            .underlineTextField(color: $underlineColor2)
                            .keyboardType(.numberPad)
                            .onChange(of: peoplePerAText){newValue in
                                if(newValue.isEmpty || newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
                                    self.underlineColor2 = Color.red
                                    self.pplPerAError = "أدخل قيمة عددية مقبولة"
                                    self.isPplNValid = false
                                }
                                if(!newValue.isEmpty){
                                    if(!newValue.trimmingCharacters(in: .letters).isEmpty &&
                                       !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !newValue.trimmingCharacters(in: .symbols).isEmpty){
                                        if(Int(newValue)! > 100 || Int(newValue)! <= 0){
                                            self.underlineColor2 = Color.red
                                            self.pplPerAError = "أدخل قيمة عددية مقبولة"
                                            self.isPplNValid = false
                                        }
                                        else {
                                            self.isPplNValid = true
                                            self.pplPerAError = ""
                                            self.peoplePerA = Int(newValue)!
                                            self.underlineColor2 = Color(UIColor.init(named: "mainDark")!)
                                        }
                                    }
                                    else {
                                        self.underlineColor2 = Color.red
                                        self.pplPerAError = "أدخل قيمة عددية مقبولة"
                                        self.isPplNValid = false
                                    }
                                }
                            }
                        
                        TextField("", text: $pplPerAError).font(Font.custom("Tajawal", size: 13)).foregroundColor(.red)
                            .disabled(true).multilineTextAlignment(.trailing)
                            .padding(.trailing, 10)
                        
                        
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .center) {
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
                        //                    .padding(.top, 20)
                        .disabled(!isDurationValid || !isPplNValid)
                    }.frame(maxWidth: .infinity)
                    
                } else {
                    // Fallback on earlier versions
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
        if (isDurationValid && isPplNValid){
            return mainDark
        } else {
            return .gray
        }
    }
    
    func saveData() {
        print("hereeeee1111")
        let duration = 30.0
        let apList = createAppointmentList()
        // Here
        let apt = BloodAppointment(appointments: apList, type: "blood", startTime: selectedDate, endTime: endDate, aptDate: date, hospital: Constants.UserInfo.userID, aptDuration: duration, donors: peoplePerA, mainDocID: "")
        
        aptVM.addData(apt: apt)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
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
        
        var currentDate = selectedDate
        var num = 0
        
        while(currentDate != endDate){
            num += 1
            let currentEnd = currentDate.addingTimeInterval(30 * 60)
            
            list.append(DAppointment(type: "blood", startTime: currentDate, endTime: currentEnd, donor: "", hName: Constants.UserInfo.userID, confirmed: "Pending", booked: false))
            
            currentDate = currentDate.addingTimeInterval(30 * 60)
        }
        
        print("\(list.count)")
        return list
        
    }
    
}

struct PopupAddForm_Previews: PreviewProvider {
    static var previews: some View {
        PopupAddForm(controller: ManageAppointmentsViewController(), date: Date())
    }
}


extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .trailing,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func underlineTextField(color: Binding<Color>) -> some View {
        self
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor(color.wrappedValue)
            .padding(10)
    }
    
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

