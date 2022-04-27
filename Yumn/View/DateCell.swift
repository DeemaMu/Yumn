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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
