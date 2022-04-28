//
//  TimeCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 29/04/2022.
//

import UIKit


class TimeCell: UITableViewCell {
    
    
    @IBOutlet weak var timeSlotBtn: UIButton!
    
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    @IBOutlet weak var radioLabel: UIImageView!
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onPressedDateBtn(_ sender: Any) {
        
        //Toggle the image
        
        
       
    }
    
    
    func setShadow(){
        
        timeSlotBtn.layer.backgroundColor = UIColor.white.cgColor
        timeSlotBtn.layer.cornerRadius = 15
    
        timeSlotBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        timeSlotBtn.layer.shadowColor = UIColor.gray.cgColor
        timeSlotBtn.layer.shadowOpacity = 1
        timeSlotBtn.layer.shadowRadius = 7
        timeSlotBtn.layer.masksToBounds = false
    }
    
}
