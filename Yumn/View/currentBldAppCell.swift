//
//  currentBldAppCell.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 13/08/1443 AH.
//

import UIKit

class currentBldAppCell: UITableViewCell {

    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var cityAndArea: UILabel!
    @IBOutlet weak var locBtn: UIButton!
    
    @IBOutlet weak var locView: UIView!
    @IBOutlet weak var cancelAppBtn: UIButton!
    @IBOutlet weak var editAppBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // make the btn corners rounded
        editAppBtn.layer.cornerRadius = 9
        editAppBtn.layer.masksToBounds = true
        
        
        /*
        guard let customFontForCell = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        
        hospitalName.font = UIFontMetrics.default.scaledFont(for: customFontForCell)
        hospitalName.adjustsFontForContentSizeCategory = true
        hospitalName.font = hospitalName.font.withSize(19)
        
        
        date.font = UIFontMetrics.default.scaledFont(for: customFontForCell)
        date.adjustsFontForContentSizeCategory = true
        date.font = date.font.withSize(13)
        
        
        time.font = UIFontMetrics.default.scaledFont(for: customFontForCell)
        time.adjustsFontForContentSizeCategory = true
        time.font = time.font.withSize(13)
        
        
        cityAndArea.font = UIFontMetrics.default.scaledFont(for: customFontForCell)
        cityAndArea.adjustsFontForContentSizeCategory = true
        cityAndArea.font = cityAndArea.font.withSize(13)
     */
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
