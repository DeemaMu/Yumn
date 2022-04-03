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
        
        



    }}

struct BloodAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BloodAppointmentView()
    }
}


