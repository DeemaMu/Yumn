//
//  DateCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import Foundation
import UIKit

class DateCell: UITableViewCell {
    
    
  
    @IBOutlet weak var dateLabel: UILabel!
    

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateBtn: UIButton!
    
    
    var index = 0
    
    var isChosen:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        
        dayLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        
        
        //setBtnShadow()
        addshadow(top: true, left: false, bottom: true, right: true)
        
        
        
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onPressedDateBtn(_ sender: Any) {
        
        //Toggle the color
        
        if (dateBtn.backgroundColor == UIColor.white){
            
            dateBtn.backgroundColor  = UIColor(named: "mainDark")

        dayLabel.textColor = UIColor.white
        dateLabel.textColor = UIColor.white
    }
    
    else{
        
        dateBtn.backgroundColor = UIColor.white
        
        dayLabel.textColor = UIColor(named: "mainDark")
        dateLabel.textColor = UIColor(named: "mainDark")
        
        
        
    }
        
        
    }
    
    
   
    
    
    func addshadow(top: Bool,
                       left: Bool,
                       bottom: Bool,
                       right: Bool,
                       shadowRadius: CGFloat = 2.0) {
        dateBtn.layer.cornerRadius = 15
     
    
        dateBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        dateBtn.layer.shadowColor = UIColor.gray.cgColor
        dateBtn.layer.shadowOpacity = 0.5
        dateBtn.layer.shadowRadius = 15
        dateBtn.layer.masksToBounds = false
        
       

/*
        dateBtn.layer.masksToBounds = false
        dateBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        dateBtn.layer.shadowRadius = shadowRadius
        dateBtn.layer.shadowOpacity = 1.0
*/
            let path = UIBezierPath()
            var x: CGFloat = 0
            var y: CGFloat = 0
            var viewWidth = self.frame.width
            var viewHeight = self.frame.height

            // here x, y, viewWidth, and viewHeight can be changed in
            // order to play around with the shadow paths.
            if (top) {
                y+=(shadowRadius+1)
            }
            if (bottom) {
                viewHeight-=(shadowRadius+1)
            }
            if (left) {
                x+=(shadowRadius+1)
            }
            if (right) {
                viewWidth-=(shadowRadius+1)
            }
            // selecting top most point
            path.move(to: CGPoint(x: x, y: y))
            // Move to the Bottom Left Corner, this will cover left edges
            /*
             |☐
             */
            path.addLine(to: CGPoint(x: x, y: viewHeight))
            // Move to the Bottom Right Corner, this will cover bottom edge
            /*
             ☐
             -
             */
            path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
            // Move to the Top Right Corner, this will cover right edge
            /*
             ☐|
             */
            path.addLine(to: CGPoint(x: viewWidth, y: y))
            // Move back to the initial point, this will cover the top edge
            /*
             _
             ☐
             */
            path.close()
        dateBtn.layer.shadowPath = path.cgPath
        }
    

}
