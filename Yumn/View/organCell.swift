//
//  organCell.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 18/07/1443 AH.
//

import UIKit

class organCell: UITableViewCell {

    @IBOutlet weak var organ: UILabel!
    @IBOutlet weak var organValue: UILabel!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        decreaseBtn.layer.cornerRadius = decreaseBtn.frame.width/2
        decreaseBtn.layer.masksToBounds = true
       
        increaseBtn.layer.cornerRadius = increaseBtn.frame.width/2
        increaseBtn.layer.masksToBounds = true
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        // font style for blood
        organ.font = UIFontMetrics.default.scaledFont(for: customFont)
        organ.adjustsFontForContentSizeCategory = true
        organ.font = organ.font.withSize(15)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
