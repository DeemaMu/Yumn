//
//  AfterDeathOrganSelection.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/04/2022.
//

import SwiftUI
import Firebase


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
    
    var organsPointer = 0
    
    let organs: [String] = ["الكلى", "الكبد", "الرئتين", "البنكرياس", "القلب", "الامعاء", "العظام", "نخاع العظم", "الجلد", "القرنيات"]
    let selected = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVGrid(columns: items, alignment: .center) {
                ForEach(organs.dropLast(organs.count % 3), id: \.self) { index in
                    card(organ: index)
                }
            }
            LazyHStack {
                ForEach(organs.suffix(organs.count % 3), id: \.self) { index in
                    card(organ: index as! String)
                }
            }
        }
    }
    
    
    @ViewBuilder
    func card(organ: String) -> some View{
        Button(action: {
            buttonPressed()
        }
        ) {
            Text(organ).font(Font.custom("Tajawal", size: 15))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
                .fill(mainDark)
        )
        .frame(width: 90, height: 90, alignment: .center)
    }
    
    func buttonPressed(){
        
    }
    
}

struct AfterDeathOrganSelection_Previews: PreviewProvider {
    static var previews: some View {
        AfterDeathOrganSelection()
    }
}


