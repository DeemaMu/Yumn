//
//  File.swift
//  Yumn
//
//  Created by Rawan Mohammed on 13/02/2022.
//

import Foundation
import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadiusV
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidthV
        }
    }
    
    @IBInspectable var borderColorV: UIColor? = UIColor.white {
        didSet {
            layer.borderColor = borderColorV?.cgColor
        }
    }
    
//    @IBInspectable var cornerRadiusV: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    @IBInspectable var borderWidthV: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable var borderColorV: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
}
