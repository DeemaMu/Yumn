//
//  MaterialSegmentedControl.swift
//  MaterialDesignWidgets
//
//  Created by Michael Ho on 04/27/20.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit
import SwiftUI
import MaterialDesignWidgets

@IBDesignable
open class MaterialSegmentedControlR: UIControl {
    
    public var selectedSegmentIndex = 2
    
    var stackView: UIStackView!
    open var viewWidth: Int = 0
    open var selector: UIView!
    open var segments = [UIButton]() {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    /**
     The foreground color of the segment.
     */
    @IBInspectable public var foregroundColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    /**
     The boolean to set whether the segment control displays the original color of the icon.
     */
    @IBInspectable public var preserveIconColor: Bool = false {
        didSet {
            updateViews()
        }
    }
    
    public enum SelectorStyle {
        case fill
        case outline
        case line
    }
    public var selectorStyle: SelectorStyle = .line {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectorColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectedForegroundColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     Convenience initializer of MaterialSegmentedControl.
     
     - Parameter segments:        The segment in UIButton form.
     - Parameter selectorStyle:   The style of the selector, fill, outline and line are supported.
     - Parameter fgColor:         The foreground color of the non-selected segment.
     - Parameter selectedFgColor: The foreground color of the selected segment.
     - Parameter selectorColor:   The color of the selector.
     - Parameter bgColor:         Background color.
     */
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line,
                            fgColor: UIColor, selectedFgColor: UIColor, selectorColor: UIColor, bgColor: UIColor) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = fgColor
        self.selectedForegroundColor = selectedFgColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
    }
    /**
     Convenience init of material design segmentedControl using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom colors
     set to the segmentedControl.
     
     - Parameter segments:      The segment in UIButton form.
     - Parameter selectorStyle: The style of the selector, fill, outline and line are supported.
     */
    @available(iOS 13.0, *)
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = .label
        self.selectedForegroundColor = .label
        switch selectorStyle {
        case .fill:
            self.selectorColor = .systemGray3
            self.backgroundColor = .systemFill
        default:
            self.selectorColor = .label
            self.backgroundColor = .systemBackground
        }
    }
    
    open func appendIconSegment(icon: UIImage? = nil, preserveIconColor: Bool = true, rippleColor: UIColor, cornerRadius: CGFloat = 12.0) {
        self.preserveIconColor = preserveIconColor
        let button = MaterialButton(icon: icon, textColor: nil, bgColor: rippleColor, cornerRadius: cornerRadius)
        button.rippleLayerAlpha = 0.15
        self.segments.append(button)
    }
    
    open func appendSegment(icon: UIImage? = nil, text: String? = nil,
                            textColor: UIColor?, font: UIFont? = nil, rippleColor: UIColor,
                            cornerRadius: CGFloat = 12.0) {
//        let button = MaterialButton(icon: icon, text: text, textColor: textColor, bgColor: rippleColor, cornerRadius: cornerRadius)
        let button = MaterialButton(icon: icon, text: text, font: font, textColor: textColor, bgColor: rippleColor, cornerRadius: cornerRadius, withShadow: false)
        button.rippleLayerAlpha = 0.15
        self.segments.append(button)
    }
    
    open func appendTextSegment(text: String, textColor: UIColor?, font: UIFont? = nil,
                                rippleColor: UIColor, cornerRadius: CGFloat = 12.0) {
        self.appendSegment(text: text, textColor: textColor, font: font, rippleColor: rippleColor, cornerRadius: cornerRadius)
    }
    
    func updateViews() {
        guard segments.count > 0 else { return }
        
        for idx in 0..<segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
        
        // Create a StackView
        stackView = UIStackView(arrangedSubviews: segments, axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
        stackView.alignment = .fill
        
//        let start:Double = Double((self.superview?.frame.width)!)
//        let end:Double = Double((self.superview?.frame.width)!) / Double(segments.count)
        
        selector = UIView(frame: .zero)
        if let first = segments.last {
            selector.setCornerBorder(cornerRadius: first.layer.cornerRadius)
        }
        
        switch selectorStyle {
        case .fill, .line:
            selector.backgroundColor = selectorColor
        case .outline:
            selector.setCornerBorder(color: selectorColor, cornerRadius: selector.layer.cornerRadius, borderWidth: 1.5)
        }
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        [selector, stackView].forEach { (view) in
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let firstBtn = segments.last {
            buttonTapped(button: firstBtn)
//            moveView(selector, toX: (selector.superview?.frame.width)!)
        }
        
        self.layoutSubviews()
    }
    // AutoLayout
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        switch selectorStyle {
        case .fill, .outline:
            selector.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        case .line:
            selector.heightAnchor.constraint(equalToConstant: 3).isActive = true
        }
        
        if let selector = selector, let first = stackView.arrangedSubviews.last {
            self.addConstraint(NSLayoutConstraint(item: selector, attribute: .width, relatedBy: .equal, toItem: first, attribute: .width, multiplier: 1, constant: 0))
        }
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.layoutIfNeeded()
        buttonTapped(button: segments.last!)

    }
    
    @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            let image = btn.image(for: .normal)
            btn.setTitleColor(foregroundColor, for: .normal)
            btn.setImage(preserveIconColor ? image : image?.colored(foregroundColor))
            
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.setImage(preserveIconColor ? image : image?.colored(selectedForegroundColor))
                btn.setTitleColor(selectorStyle == .line ? selectedForegroundColor : selectedForegroundColor, for: .normal)
                moveView(selector, toX: btn.frame.origin.x)
            }
        }
        sendActions(for: .valueChanged)
    }
    /**
     Moves the view to the right position.
     
     - Parameter view:       The view to be moved to new position.
     - Parameter duration:   The duration of the animation.
     - Parameter completion: The completion handler.
     - Parameter toView:     The targetd view frame.
     */
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: toX, y: 0.0)
        }, completion: completion)
    }
}

//
//  Extensions.swift
//  MaterialDesignWidgets
//
//  Created by Ho, Tsung Wei on 5/16/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

public typealias BtnAction = (()->())?

// MARK: - UIColor
extension UIColor {
    /**
     Convert RGB value to CMYK value.
     
     - Parameters:
     - r: The red value of RGB.
     - g: The green value of RGB.
     - b: The blue value of RGB.
     
     Returns a 4-tuple that represents the CMYK value converted from input RGB.
     */
    open func RGBtoCMYK(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        
        if r==0, g==0, b==0 {
            return (0, 0, 0, 1)
        }
        var c = 1 - r
        var m = 1 - g
        var y = 1 - b
        let minCMY = min(c, m, y)
        c = (c - minCMY) / (1 - minCMY)
        m = (m - minCMY) / (1 - minCMY)
        y = (y - minCMY) / (1 - minCMY)
        return (c, m, y, minCMY)
    }
    
    /**
     Convert CMYK value to RGB value.
     
     - Parameters:
     - c: The cyan value of CMYK.
     - m: The magenta value of CMYK.
     - y: The yellow value of CMYK.
     - k: The key/black value of CMYK.
     
     Returns a 3-tuple that represents the RGB value converted from input CMYK.
     */
    open func CMYKtoRGB(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        return (r, g, b)
    }
    
    open func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(r: ciColor.red, g: ciColor.green, b: ciColor.blue)
        let kVal = originCMYK.k > 0.3 ? originCMYK.k - 0.2 : originCMYK.k + 0.2
        let tintRGB = CMYKtoRGB(c: originCMYK.c, m: originCMYK.m, y: originCMYK.y, k: kVal)
        return UIColor(red: tintRGB.r, green: tintRGB.g, blue: tintRGB.b, alpha: 1.0)
    }
}

// MARK: - UIButton

extension UIButton {
    /**
     Set button image for all button states
     
     - Parameter image: The image to be set to the button.
     */
    open func setImage(_ image: UIImage?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setImage(image, for: state)
        }
    }
    /**
     Set button title for all button states
     
     - Parameter text: The text to be set to the button title.
     */
    open func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
    }
}

// MARK: - UIImage

extension UIImage {
    /**
     Create color rectangle as image.
     
     - Parameter color: The color to be created as an UIImage
     - Parameter size:  The size of the UIImage, no need to be set when creating
     */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil}
        self.init(cgImage: cgImage)
    }
    
    /**
     Change the color of the image.
     
     - Parameter color: The color to be set to the UIImage.
     
     Returns an UIImage with specified color
     */
    public func colored(_ color: UIColor?) -> UIImage? {
        if let newColor = color {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        return self
    }
}

// MARK: UIView

extension UIView {
    /**
     Set the corner radius of the view.
     
     - Parameter color:        The color of the border.
     - Parameter cornerRadius: The radius of the rounded corner.
     - Parameter borderWidth:  The width of the border.
     */
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    /**
     Set the shadow layer of the view.
     
     - Parameter bounds:       The bounds in CGRect of the shadow.
     - Parameter cornerRadius: The radius of the shadow path.
     - Parameter shadowRadius: The radius of the shadow.
     */
    open func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1, color: UIColor) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    
    /**
     Remove all subviews.
     */
    public func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIStackView {
    
    /**
     Convenient initializer.
     
     - Parameter arrangedSubviews: all arranged subviews to be put to the stack.
     - Parameter axis: The arranged axis of the stack view.
     - Parameter distribution: The distribution of the stack view.
     - Parameter spacing: The spacing between each view in the stack view.
     */
    convenience init(arrangedSubviews: [UIView]? = nil, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) {
        if let arrangedSubviews = arrangedSubviews {
            self.init(arrangedSubviews: arrangedSubviews)
        } else {
            self.init()
        }
        (self.axis, self.spacing, self.distribution) = (axis, spacing, distribution)
    }
}
