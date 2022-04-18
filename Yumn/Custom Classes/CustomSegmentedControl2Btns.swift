//
//  CustomSegmentedControl2Btns.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 18/04/2022.
//

import Foundation
import UIKit
protocol CustomSegmentedControl2BtnsDelegate:class {
    func change(to index:Int)
}

class CustomSegmentedControl2Btns: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor:UIColor = #colorLiteral(red: 0.5490196078, green: 0.5568627451, blue: 0.5529411765, alpha: 1)
    var selectorViewColor: UIColor = #colorLiteral(red: 0.5254901961, green: 0.7921568627, blue: 0.7647058824, alpha: 1)
    var selectorTextColor: UIColor =  #colorLiteral(red: 0.5254901961, green: 0.7921568627, blue: 0.7647058824, alpha: 1)
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 2
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl2Btns {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: frame.width - (frame.width / CGFloat(self.buttonTitles.count)), y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            
            let quote = buttonTitle
            guard let customFont = UIFont(name: "Tajawal", size: 15) else {
                fatalError("""
                    Failed to load the "Tajawal" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
//            let font = UIFont(name: "Tajawl", size: 20)
            let attributes = [NSAttributedString.Key.font: customFont]
            let attributedQuote = NSAttributedString(string: quote, attributes: attributes)
            
            button.setAttributedTitle(attributedQuote , for: .normal)
            
            buttons.append(button)
        }
   
    
    
}
}
