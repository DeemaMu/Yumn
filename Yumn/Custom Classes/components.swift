//
//  components.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 02/08/1443 AH.
//

import Foundation
import UIKit

class components {
    
    
    
    func showToast(message : String, font: UIFont, image: UIImage, viewC : UIViewController){

      let toastLabel = UILabel(frame: CGRect(x: 5, y: 45, width: viewC.view.frame.size.width-10, height: 70))
          

          toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          toastLabel.textColor = UIColor.white
          toastLabel.font = font
          toastLabel.textAlignment = .center;
          toastLabel.text = message
          toastLabel.alpha = 1.0
          toastLabel.layer.cornerRadius = 10;
          toastLabel.clipsToBounds  =  true
        viewC.view.addSubview(toastLabel)
     

          
      let imageView = UIImageView(frame: CGRect(x: viewC.view.frame.size.width-70, y: 10, width: 45, height: 45))
          imageView.layer.masksToBounds = true

      imageView.image = image
          imageView.layer.cornerRadius = 10

          toastLabel.addSubview(imageView)
        viewC.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0, options:
                      
                      
                      .transitionFlipFromTop, animations: {
                          
                          
           toastLabel.alpha = 0.0
      }, completion: {(isCompleted) in
          toastLabel.removeFromSuperview()
      })
  }
}
