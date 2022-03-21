//
//  descriptionTextbox.swift
//  Yumn
//
//  Created by Deema Almutairi on 18/03/2022.
//

import Foundation
import SwiftUI


struct descriptionTextbox: View {
    @EnvironmentObject var obj : observed
    var body: some View {
        VStack{
            MultiTextField()
                .frame( width: 300 , height: 100)
                .background(Color.white)
                .cornerRadius(15);
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        descriptionTextbox()
    }
}

struct MultiTextField: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return MultiTextField.Coordinator(parent1: self)
    }
    
    @EnvironmentObject var obj : observed
    func makeUIView(context: UIViewRepresentableContext<MultiTextField>) -> some UITextView {
        
        guard let customFont = UIFont(name: "Tajawal-Regular", size: 17) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let view = UITextView()
        view.setCornerBorder(color: UIColor.init(named: "mainLight"), cornerRadius: 20.0, borderWidth: 1)
        view.font = customFont
        view.textAlignment = .right
        view.textColor = UIColor.black
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.textContainer.lineFragmentPadding = 20
        view.textContainer.maximumNumberOfLines = 4
        self.obj.size = view.contentSize.height
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MultiTextField>) {
        
    }
    
//    func validateDescription(_ error : String){
//        if (error == "limits") {
//
//
//        }
//        if (error == "specailChar"){
//
//        }
//        if (error == "pass"){
//
//        }
//
//    }
    
    class Coordinator : NSObject,UITextViewDelegate {
        var parent : MultiTextField
        init(parent1 : MultiTextField){
            parent = parent1
        }
        

        func textViewDidChange(_ textView: UITextView) {
            if (textView.text.count > 10){
                textView.setCornerBorder(color: UIColor.red, cornerRadius: 20.0, borderWidth: 1)
                Constants.VolunteeringOpp.DesError = "limits"
                Constants.VolunteeringOpp.isValidDes = false
            }
//            if (containsSpecialCharacter(textView.text)){
//                textView.setCornerBorder(color: UIColor.red, cornerRadius: 20.0, borderWidth: 1)
//                parent.validateDescription("specailChar")
//                Constants.VolunteeringOpp.DesError = "specailChar"
//                Constants.VolunteeringOpp.isValidDes = false
//            }
            else if (textView.text.count <= 10){
                textView.setCornerBorder(color: UIColor.init(named: "mainLight"), cornerRadius: 20.0, borderWidth: 1)
                Constants.VolunteeringOpp.DesError = "pass"
                Constants.VolunteeringOpp.isValidDes = true
            }
        }

        func containsSpecialCharacter(_ value : String) -> Bool{
            let regex = ".*[^A-Za-z0-9].*"
            let testString = NSPredicate(format:"SELF MATCHES %@", regex)
            return testString.evaluate(with: value)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            Constants.VolunteeringOpp.description = textView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

class observed : ObservableObject {
    @Published var size : CGFloat = 0
}

