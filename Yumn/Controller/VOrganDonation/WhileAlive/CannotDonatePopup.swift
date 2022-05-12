//
//  CannotDonatePopup.swift
//  Yumn
//
//  Created by Rawan Mohammed on 01/05/2022.
//

import SwiftUI

struct CannotDonatePopup: View {
    let config: Configuration
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 30){
                Text("شكرًا على مساهمتك").font(Font.custom("Tajawal", size: 15))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                
                VStack(spacing: 5){
                    Text("ولكن لا يمكنك حجز اكثر من موعد لنفس العضو").font(Font.custom("Tajawal", size: 15))
                        .foregroundColor(textGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                }
                
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                            let x =
                            config.hostingController?.parent as! AliveFirstVC
                            x.hidePopup()
                    }
                    ) {
                        Text("العودة").font(Font.custom("Tajawal", size: 16))
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
                    .frame(width: 100, height: 30, alignment: .center)
                    
                    
                }
                
            }
                
        }.padding(.top, 20)
    }
}

struct CannotDonatePopup_Previews: PreviewProvider {
    static var previews: some View {
        CannotDonatePopup(config: Configuration())
    }
}
