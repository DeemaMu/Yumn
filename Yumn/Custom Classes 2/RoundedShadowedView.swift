//
//  RoundedShadowedView.swift
//  Yumn
//
//  Created by Rawan Mohammed on 14/02/2022.
//

import Foundation
import UIKit

@IBDesignable
class RoundedShadowedView: UIView {
    
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


    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
}
