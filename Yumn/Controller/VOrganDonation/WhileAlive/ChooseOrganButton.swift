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
    let whiteBg = Color(UIColor.white)
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))

    
    var body: some View {
        HStack(spacing: 0){
            VStack(){
                Image("liver")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading)
                            .padding(.trailing)
                Text("التبرع بجزء من الكبد").font(Font.custom("Tajawal", size: 18))
                    .foregroundColor(mainLight)
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(whiteBg)
                .cornerRadius(20, corners: [.bottomLeft, .topLeft])
                .shadow(color: shadowColor,
                        radius: 6, x: 0
                        , y: 6)
                .onTapGesture {
                    controller.moveToLiverSection()
                }
                
            VStack(){
                Image("alive_organ_donation")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading)
                            .padding(.trailing)
                Text("التبرع بكلية").font(Font.custom("Tajawal", size: 18))
                    .foregroundColor(mainLight)

                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(whiteBg)
                .cornerRadius(20, corners: [.bottomRight, .topRight])
                .shadow(color: shadowColor,
                        radius: 6, x: 3
                        , y: 6)
                .onTapGesture {
                    controller.moveToKindneySection()
                }
            
        }
            .frame(width: UIScreen.screenWidth - 80, height: UIScreen.screenHeight - 600, alignment: .center).background(
                RoundedRectangle(
                    cornerRadius: 40,
                    style: .continuous
                )
                    .fill(.white)
            )
//            .shadow(color: shadowColor,
//                    radius: 6, x: 0
//                    , y: 6)
    }
}

struct ChooseOrganButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseOrganButton(controller: AliveFirstVC())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
