//
//  BloodAppointmentView.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/04/2022.
//

import SwiftUI


extension Color {
    static let mainLight = Color("mainLight")
}


struct BloodAppointmentView: View {
    
    init() {
                let navBarAppearance = UINavigationBar.appearance()
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
              }
    
    var body: some View {
        
        ZStack{
        
        NavigationView {
        
                        ZStack {
                            Color.mainLight.edgesIgnoringSafeArea(.all)

            
                    Text("")
                .navigationBarTitle(Text("حجز موعد للتبرع بالدم")
                                        .font(Font.custom("Tajawal", size: 20)), displayMode: .inline)
                                     .foregroundColor(.white)

                            .navigationBarItems(leading:
                            HStack {
                                                            }, trailing:
                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "arrow.right")
                                        .font(.largeTitle)
                                }
                            })


                        }
            
            
                                   
                
            

        }.foregroundColor(.white)
        
        ScrollView {
            HStack(spacing: 20) {
                ForEach(0..<10) {
                    Text("Item \($0)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 200, height: 200)
                        .background(Color.red)
                }
            }
        }
        .frame(height: 350)
        flipsForRightToLeftLayoutDirection(true)
        .environment(\.layoutDirection, .rightToLeft)





    }}
}



struct BloodAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BloodAppointmentView()
    }
}


