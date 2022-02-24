//
//  trial1.swift
//  Yumn
//
//  Created by Rawan Mohammed on 23/02/2022.
//

import Foundation
import UIKit
import SnapKit

class Trial1: UIViewController {
    
    
    @IBOutlet weak var trialView: UIView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.removeBorder()
        segmentedControl.addUnderlineForSelectedSegment()
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentedControl.changeUnderlinePosition()
        print("index changed")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.setupSegment()
    }
    
    
}

extension UISegmentedControl {
    
    func removeBorder(){
        
        guard let customFont = UIFont(name: "Tajawal", size: 18) else {
            fatalError("""
                             Failed to load the "Tajawal" font.
                             Make sure the font file is included in the project and the font name is spelled correctly.
                             """
            )
        }
        
        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.clear
        }
        
        
        setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.white), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: UIColor.white), for: .selected, barMetrics: .default)
        tintColor = UIColor.init(named: "mainLight")
        
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        //       setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font : customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
    }
    
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    func setupSegment() {
//        self.removeBorder()
//        let segmentUnderlineWidth: CGFloat = self.bounds.width
//        let segmentUnderlineHeight: CGFloat = 4.0
//        let segmentUnderlineXPosition = self.bounds.minX
//        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
//        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
//        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
//        segmentUnderline.backgroundColor = UIColor.clear
        self.removeBorder()
//        self.addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
    }
    
    func addUnderlineForSelectedSegment(){
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 4.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.init(named: "mainLight")
        underline.tag = 1
        self.addSubview(underline)
        
        
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
        
    }
}


//extension UIImage{
//
//    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        let graphicsContext = UIGraphicsGetCurrentContext()
//        graphicsContext?.setFillColor(color)
//        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
//        graphicsContext?.fill(rectangle)
//        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return rectangleImage!
//    }
//}

//extension UISegmentedControl {
//
// func removeBorders() {
//
//     guard let customFont = UIFont(name: "Tajawal", size: 20) else {
//                 fatalError("""
//                     Failed to load the "Tajawal" font.
//                     Make sure the font file is included in the project and the font name is spelled correctly.
//                     """
//                 )
//             }
//
//      setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.white), for: .normal, barMetrics: .default)
//      setBackgroundImage(imageWithColor(color: UIColor.white), for: .selected, barMetrics: .default)
//
//     tintColor = UIColor.init(named: "mainLight")
//      setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//     setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font : customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
// }
//
// private func imageWithColor(color: UIColor) -> UIImage {
//      let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
//      UIGraphicsBeginImageContext(rect.size)
//      let context = UIGraphicsGetCurrentContext()
//      context!.setFillColor(color.cgColor);
//      context!.fill(rect);
//      let image = UIGraphicsGetImageFromCurrentImageContext();
//      UIGraphicsEndImageContext();
//      return image!
// }
//}
//
//extension UIColor {
//
//    @nonobjc class var TSPrimary: UIColor {
//
//        return UIColor(red:0.85, green:0.11, blue:0.38, alpha:1.0)
//
//    }
//
//}
