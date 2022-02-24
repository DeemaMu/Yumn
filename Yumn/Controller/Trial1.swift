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
    
    let segmentindicator: UIView = {
            
            let v = UIView()
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = UIColor.TSPrimary
            
            return v
        }()
    
    @IBOutlet weak var trialView: UIView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        segmentedControl.removeBorders()
        segmentedControl.backgroundColor = .clear
                segmentedControl.tintColor = .clear
                
                segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)

                segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.TSPrimary], for: .selected)
        
        self.view.addSubview(segmentindicator)
        
        setupLayout()


    }
    
    func setupLayout() {
           
           segmentindicator.snp.makeConstraints { (make) in
               
               make.top.equalTo(segmentedControl.snp.bottom).offset(3)
               make.height.equalTo(2)
               
               make.width.equalTo(15 + segmentedControl.titleForSegment(at: 0)!.count * 8)
               make.centerX.equalTo(segmentedControl.snp.centerX).dividedBy(segmentedControl.numberOfSegments)
               
           }
           
       }
       
       @IBAction func indexChanged(_ sender: UISegmentedControl) {
           let numberOfSegments = CGFloat(segmentedControl.numberOfSegments)
           let selectedIndex = CGFloat(sender.selectedSegmentIndex)
           let titlecount = CGFloat((segmentedControl.titleForSegment(at: sender.selectedSegmentIndex)!.count))
           segmentindicator.snp.remakeConstraints { (make) in
               
               make.top.equalTo(segmentedControl.snp.bottom).offset(3)
               make.height.equalTo(2)
               make.width.equalTo(15 + titlecount * 8)
               make.centerX.equalTo(segmentedControl.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(selectedIndex-1.0)*2.0))
               
           }
           
           UIView.animate(withDuration: 0.5, animations: {
               self.view.layoutIfNeeded()
               self.segmentindicator.transform = CGAffineTransform(scaleX: 1.4, y: 1)
           }) { (finish) in
               UIView.animate(withDuration: 0.4, animations: {
                   self.segmentindicator.transform = CGAffineTransform.identity
               })
           }
       }

}

extension UISegmentedControl {

 func removeBorders() {
     
     guard let customFont = UIFont(name: "Tajawal", size: 20) else {
                 fatalError("""
                     Failed to load the "Tajawal" font.
                     Make sure the font file is included in the project and the font name is spelled correctly.
                     """
                 )
             }
     
      setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.white), for: .normal, barMetrics: .default)
      setBackgroundImage(imageWithColor(color: UIColor.white), for: .selected, barMetrics: .default)

     tintColor = UIColor.init(named: "mainLight")
      setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
     setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(named: "mainLight")!, NSAttributedString.Key.font : customFont, NSAttributedString.Key.underlineColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], for: .selected)
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
}

extension UIColor {
    
    @nonobjc class var TSPrimary: UIColor {
        
        return UIColor(red:0.85, green:0.11, blue:0.38, alpha:1.0)
        
    }
    
}
