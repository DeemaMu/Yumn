//
//  currentApplicantTableViewCell.swift
//  testingFeatures
//
//  Created by Modhi Abdulaziz on 09/09/1443 AH.
//

import UIKit

class currentApplicantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cityAndArea: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    //@IBOutlet weak var locBtn: UIButton!
    //@IBOutlet weak var showLoc: UIButton!
    //also btn for email
    
    override func awakeFromNib() {
        super.awakeFromNib()

        acceptBtn.layer.cornerRadius = 9
        acceptBtn.layer.masksToBounds = true
        
        rejectBtn.layer.cornerRadius = 9
        rejectBtn.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
