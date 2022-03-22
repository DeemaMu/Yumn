//
//  CustomPopUpView.swift
//  Yumn
//
//  Created by Rawan Mohammed on 18/03/2022.
//

import SwiftUI

extension View{
    // Buliding custom modifier for custom popup view
    @available(iOS 15.0, *)
    func popupNavigationView<Content: View>(horizontalPadding: CGFloat = 40, show: Binding<Bool>, @ViewBuilder content: @escaping ()-> Content)->some View{
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
            if show.wrappedValue{
                // Geometry Reader for reading Container Frame
                GeometryReader{ proxy in
                    
//                    Color.black
//                        .opacity(0.15)
//                        .ignoresSafeArea()
//                        .padding(EdgeInsets(top: -100, leading: -200, bottom: -300, trailing: -200))
                    
                    let size = proxy.size
                    
                    NavigationView{
                        content()
                    }
                    .frame(width: size.width - horizontalPadding, height: size.height / 1.7, alignment: .center)
                    .cornerRadius(15)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                }
            }
        }
    }
}
