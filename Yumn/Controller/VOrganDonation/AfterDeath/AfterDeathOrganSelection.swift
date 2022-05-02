//
//  AfterDeathOrganSelection.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/04/2022.
//

import SwiftUI
import Firebase
import UIKit


struct AfterDeathOrganSelection: View {
    //    @State var controller: AfterDeathODSecondController = AfterDeathODSecondController()
    
    let config: Configuration
    
    let userID = Auth.auth().currentUser!.uid
    @State var donor = Donor()
    let db = Firestore.firestore()

    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    
    let items: [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
    ]
    
    @ObservedObject var organsVM = OrgansVM()
    
    var organsPointer = 0
    
    @State var showError = false
    
    
    let organs: [String] = ["الكلى", "الكبد", "الرئتين", "البنكرياس", "القلب", "الامعاء", "العظام", "نخاع العظم", "الجلد", "القرنيات"]
    
    @State var unwrappedOrgans: [String] = []
    
    
    @State var checked = false
    
    
    var body: some View {
        VStack(spacing: 20){
            HStack(){
                HStack(){
                    Text("الكل").font(Font.custom("Tajawal", size: 15))
                        .foregroundColor(.gray).padding(.top,4)
                    RadioButton(checked: $checked)
                }.padding(.leading)
                
                Spacer()
                Text("الأعضاء المراد التبرع بها:").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(mainDark)
            }.onChange(of: checked){ newValue in
                self.selectAll()
            }
            .padding(.trailing)
            .padding(.bottom,10)
            
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: items, alignment: .center) {
                    ForEach(organs.dropLast(organs.count % 3), id: \.self) { index in
                        card(organ: index)
                    }
                }
                LazyHStack {
                    ForEach(organs.suffix(organs.count % 3), id: \.self) { index in
                        card(organ: index)
                    }
                }
            }
            
            if(showError){
                Text("الرجاء اختيار عضو").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(.red)
            }
            
            // Save Selection Button
            Button(action: {
                // check if user has at least selected one organ to donate
                // if not, display error
                if(self.checkSelection()){
                    // Save Array of selected organs
                    self.changeOrgans()
                    showError = false
                    // Display confirmation message from the controller
                    let x =
                    config.hostingController?.parent as! AfterDeathODSecondController
                    x.showConfirmationMessage(selected: self.organsVM.selected, donor: self.donor)
                    
                } else {
                    self.showError = true
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
            
        }.onAppear(){
            self.getUser()
        }
        
    }
    
    
    @ViewBuilder
    func card(organ: String) -> some View{
        let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))

        
        Button(action: {
            buttonPressed(organ: organ)
        }
        ) {
            Text(organ).font(Font.custom("Tajawal", size: 15))
                .foregroundColor(self.organsVM.selected[organ]! ? .white : mainDark)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
                .fill(self.organsVM.selected[organ]! ? mainDark : .white)
        )
        .frame(width: 90, height: 90, alignment: .center)
        .shadow(color: shadowColor,
                radius: self.organsVM.selected[organ]! ? 0 : 3, x: 0
                , y:  self.organsVM.selected[organ]! ? 0 : 6)
    }
    
    // On organ selected, change it value and hide error message
    func buttonPressed(organ: String){
        self.organsVM.selected[organ]?.toggle()
        for organ in self.organsVM.selected {
            if(organ.value){
                showError = false
            }
        }
    }
    
    func checkSelection() -> Bool {
        for organ in self.organsVM.selected {
            if(organ.value){
                showError = false
                return true
            }
        }
        
        return false
    }
    
    func selectAll(){
        if(checked){
            for organ in self.organsVM.selected {
                self.organsVM.selected[organ.key]? = true
            }
        } else {
            for organ in self.organsVM.selected {
                self.organsVM.selected[organ.key]? = false
            }
        }
        
    }
    
    func getUser() {
        
        for organ in organsVM.selected {
            if(organ.value){
                self.unwrappedOrgans.append(organ.key)
            }
        }
        
        db.collection("volunteer").document(userID).addSnapshotListener { (querySnapshot, error) in
            
            self.donor = querySnapshot.map { (queryDocumentSnapshot) -> Donor in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let fname = data!["firstName"] as! String
                let lname = data!["lastName"] as! String
                let name = fname + " " + lname
                let city = data!["city"] as! String
                let bloodType = data!["bloodType"] as! String
                let nationalID = data!["nationalID"] as! String
                return Donor(name: name, city: city, bloodType: bloodType, organs: self.organs, nationalID: nationalID)
                
            } as! Donor
            
        }
    }

    func changeOrgans() {
        
        unwrappedOrgans.removeAll()
        
        for organ in organsVM.selected {
            if(organ.value){
                self.unwrappedOrgans.append(organ.key)
            }
        }
        
        self.donor.organs = unwrappedOrgans
    }

    
    
}

struct RadioButton: View {
    @Binding var checked: Bool    //the variable that determines if its checked
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    
    var body: some View {
        Group{
            if checked {
                ZStack{
                    Circle()
                        .fill(mainDark)
                        .frame(width: 18, height: 18)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                }.onTapGesture {self.checked = false}
            } else {
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .onTapGesture {self.checked = true}
            }
        }
    }
}

// Object to keep track of organs selected
class OrgansVM: ObservableObject {
    @Published var selected = [
        "الكلى": false,
        "الكبد":false,
        "الرئتين":false,
        "البنكرياس":false,
        "القلب":false,
        "الامعاء":false,
        "العظام":false,
        "نخاع العظم":false,
        "الجلد":false,
        "القرنيات":false,
    ]
}



struct AfterDeathOrganSelection_Previews: PreviewProvider {
    static var previews: some View {
        AfterDeathOrganSelection(config: Configuration())
    }
}


