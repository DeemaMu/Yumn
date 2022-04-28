//
//  acceptedApplicantTableViewCell.swift
//  testingFeatures
//
//  Created by Modhi Abdulaziz on 09/09/1443 AH.
//

import UIKit

class acceptedApplicantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cityAndArea: UILabel!
    @IBOutlet weak var attendBtn: UIButton!
    @IBOutlet weak var didNotAttendBtn: UIButton!
    //@IBOutlet weak var locBtn: UIButton!
    //@IBOutlet weak var showLoc: UIButton!
    //also btn for email
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        attendBtn.layer.cornerRadius = 9
        attendBtn.layer.masksToBounds = true
        
        didNotAttendBtn.layer.cornerRadius = 9
        didNotAttendBtn.layer.masksToBounds = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
