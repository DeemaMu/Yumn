//
//  oldBloodAppTableViewCell.swift
//  testingFeatures
//
//  Created by Modhi Abdulaziz on 18/08/1443 AH.
//

import UIKit

class oldBloodAppTableViewCell: UITableViewCell {

    
    @IBOutlet weak var hospitalName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var cityAndArea: UILabel!
    @IBOutlet weak var locBtn: UIButton!
    
    @IBOutlet weak var locView: UIView!
    @IBOutlet weak var showLoc: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
