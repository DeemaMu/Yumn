//
//  TimeCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 29/04/2022.
//

import UIKit


class TimeCell: UITableViewCell {
    
    

    @IBOutlet weak var timeSlotBtn: UIView!
    
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    @IBOutlet weak var radioLabel: UIImageView!
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         
        
        addshadow(top: true, left: false, bottom: true, right: true)
      

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected){
            
            radioLabel.image = UIImage(named:"radioFilled" )

            
            
        }
        else{
            
            radioLabel.image = UIImage(named:"emptyRadio" )

            
            
        }
    }
    
    
    @IBAction func onPressedDateBtn(_ sender: Any) {
        
        //Toggle the image
        
        radioLabel.image = UIImage(named:"radioFilled" )
        
        
       
    }
    
    
    func addshadow(top: Bool,
                       left: Bool,
                       bottom: Bool,
                       right: Bool,
                       shadowRadius: CGFloat = 2.0) {
        timeSlotBtn.layer.cornerRadius = 15
    
        timeSlotBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        timeSlotBtn.layer.shadowColor = UIColor.gray.cgColor
        timeSlotBtn.layer.shadowOpacity = 0.5
        timeSlotBtn.layer.shadowRadius = 15
        timeSlotBtn.layer.masksToBounds = false
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
        timeSlotBtn.layer.shadowPath = path.cgPath
        }
    
    
}
