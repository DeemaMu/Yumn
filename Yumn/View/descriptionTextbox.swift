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
                .cornerRadius(15)
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
    
    class Coordinator : NSObject,UITextViewDelegate {
        var parent : MultiTextField
        init(parent1 : MultiTextField){
            parent = parent1
        }
        
        func textViewDidChange(_ textView: UITextView) {
        
        }
        
        private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
            let text = existingText ?? ""
            let isAtLimit = text.count + newText.count <= limit
            return isAtLimit
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return self.textLimit(existingText: textField.text, newText: string, limit: 10)
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            Constants.VolunteeringOpp.description = textView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

class observed : ObservableObject {
    @Published var size : CGFloat = 0
}

