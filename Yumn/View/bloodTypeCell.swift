//
//  bloodTypeCell.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 15/07/1443 AH.
//

import UIKit

//@IBDesignable

class bloodTypeCell: UITableViewCell {
    
    
    @IBOutlet weak var bloodTypeLbl: UILabel!
    @IBOutlet weak var bloodTypeValue: UILabel!
    
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    // initialize the zib file (ui of cell)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bloodTypeLbl.textAlignment = .center
        decreaseBtn.layer.cornerRadius = decreaseBtn.frame.width/2
        decreaseBtn.layer.masksToBounds = true
        
        increaseBtn.layer.cornerRadius = increaseBtn.frame.width/2
        increaseBtn.layer.masksToBounds = true
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
