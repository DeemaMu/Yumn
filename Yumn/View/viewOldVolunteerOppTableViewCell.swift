//
//  viewOldVolunteerOppTableViewCell.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 24/09/1443 AH.
//

import UIKit

class viewOldVolunteerOppTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var workingHours: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
