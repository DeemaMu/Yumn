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
    @State var controller: AfterDeathODSecondController = AfterDeathODSecondController()
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
    
    let organs: [String] = ["الكلى", "الكبد", "الرئتين", "البنكرياس", "القلب", "الامعاء", "العظام", "نخاع العظم", "الجلد", "القرنيات"]
    var selected = [
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
    
    var body: some View {
        VStack(spacing: 20){
            HStack(){
                
                Spacer()
                Text("الأعضاء المراد التبرع بها:").font(Font.custom("Tajawal", size: 15))
                                .foregroundColor(mainDark)
            }.padding(.trailing)
            
            
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
            Button(action: {
            }
            ) {
                Text("متابعة").font(Font.custom("Tajawal", size: 20))
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
        }
        
    }
    
    
    @ViewBuilder
    func card(organ: String) -> some View{
        let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
//        let raduis = 3
//        let ySpread = 0
        
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
        
    func buttonPressed(organ: String){
        self.organsVM.selected[organ]?.toggle()
    }
    
    
    
}

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
        AfterDeathOrganSelection()
    }
}


