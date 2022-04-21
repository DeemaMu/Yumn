//
//  ChooseOrganButton.swift
//  Yumn
//
//  Created by Rawan Mohammed on 21/04/2022.
//

import SwiftUI

struct ChooseOrganButton: View {
    
    @State var controller: AliveFirstVC

    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    
    var body: some View {
        HStack(){
            VStack(){
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(mainLight)
                
            VStack(){
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }.frame(width: UIScreen.screenWidth - 90, height: UIScreen.screenHeight - 500, alignment: .center)
            .background(mainDark)
    }
}

struct ChooseOrganButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseOrganButton(controller: AliveFirstVC())
    }
}
