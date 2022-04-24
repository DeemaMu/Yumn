//
//  AODInstructions.swift
//  Yumn
//
//  Created by Rawan Mohammed on 24/04/2022.
//

import SwiftUI

struct AODInstructions: View {
    var controller: Alive2ndVC = Alive2ndVC()
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let textGrey = Color(UIColor.init(named: "textGrey")!)
    let lightGray = Color(UIColor.lightGray)
    
    var text1 =
    """
    - يخضع المتبرع الحي لفحص من أطباء نفسيين واختصاصيين اجتماعيين في المركز الزارع (تحت إدارة مستقلة عن مركز الزراعة) من خلال مقابلة شخصية معه وتوثيق ذلك ضمن النموذج المعتمد في كل مركز زراعة.
    """
    
    var text2 =
    """
    - يجرى للمتبرع فحص طبي شامل بوساطة فريق طبي مؤهل ومتخصص للتأكد من جاهزية المتبرع.
    """
    
    var text3 =
    """
    - يحق للمتبرع معرفة الفترة الزمنية اللازمة لإجراء الفحص الصحي الشامل.
    """
    
    var text4 =
    """
    - يحاط المتبرع بشكل واضح بجميع النتائج المؤكدة والمحتملة المترتبة على إجراء عملية استئصال العضو البشري.
    """
    
    init(controller: Alive2ndVC){
        self.controller = controller
    }
    
    var body: some View {
        
        ScrollView(){
            VStack(spacing: 20){
                
//                Text("الإرشادات").font(Font.custom("Tajawal", size: 20))
//                    .foregroundColor(mainDark)
                
                VStack(alignment: .trailing, spacing: 20){
                    
                        card(text: text1)
                    card(text: text2)
                    card(text: text3)
                    card(text: text4)
                }
                                
                
//                Button(
//                    action: {
//                    print("pressed2")
//                    controller.showSecondSection()
//                }
//                ) {
//                    Text("متابعة").font(Font.custom("Tajawal", size: 20))
//                        .foregroundColor(.white)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(
//                    RoundedRectangle(
//                        cornerRadius: 25,
//                        style: .continuous
//                    )
//                        .fill(mainDark)
//                )
//                .frame(width: 230, height: 59)
                
                
                
            }
//            .frame(maxHeight: .infinity, alignment: .bottom)
        }
//        .frame(maxHeight: .infinity)
    }
    
    
    @ViewBuilder
    func card(text: String) -> some View{
        Text(text).font(Font.custom("Tajawal", size: 17)).foregroundColor(textGrey).multilineTextAlignment(.trailing).lineSpacing(10)
    }
    
}

struct AODInstructions_Previews: PreviewProvider {
    static var previews: some View {
        AODInstructions(controller: Alive2ndVC())
    }
}
