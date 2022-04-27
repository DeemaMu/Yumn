//
//  ThankYouPopup.swift
//  Yumn
//
//  Created by Rawan Mohammed on 27/04/2022.
//

import SwiftUI

struct ThankYouPopup: View {
    
    let config: Configuration
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGray = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15){
                Text("قال تعالى:").font(Font.custom("Tajawal", size: 18))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 5){
                Text(" ( وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا)").font(Font.custom("Tajawal", size: 18))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("آية 32 سورة المائدة").font(Font.custom("Tajawal", size: 10))
                    .foregroundColor(textGray)
                    .multilineTextAlignment(.center)
                }
                

                Text("شكرًا على مساهمتك").font(Font.custom("Tajawal", size: 16))
                    .foregroundColor(mainLight).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Button(action: {
                        
                        var x =
                        config.hostingController?.parent as! Alive4thVC
                        x.thankYou()
                        
                    }
                    ) {
                        Text("تأكيد").font(Font.custom("Tajawal", size: 16))
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
                
            }.padding(.vertical)
                .padding(.horizontal, 25)
        }
    }
}

struct ThankYouPopup_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouPopup(config: Configuration())
    }
}
