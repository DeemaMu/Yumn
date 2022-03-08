//
//  styles.swift
//  Yumn
//
//  Created by Deema Almutairi on 08/03/2022.
//

import UIKit

class styles: UIViewController {
    
//    styles(){
//        //do nothing
//    }
    
    public func normalStyle(TextField : UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        TextField.borderStyle = .none
        TextField.layer.addSublayer(bottomLine)
    }
    
    public func activeModeStyle(TextField : UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1).cgColor
        TextField.borderStyle = .none
        TextField.layer.addSublayer(bottomLine)
    }
    
    public func turnTextFieldToRed(textfield: UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width , height: 2)
        
        bottomLine.backgroundColor = UIColor.red.cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
    }
    
    
}
