//
//  HospitalCellTableViewCell.swift
//  Yumn
//
//  Created by Rawan Mohammed on 22/02/2022.
//

import UIKit

class HospitalCellTableViewCell: UITableViewCell {

    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var bookApp: UIButton!
    @IBOutlet weak var distanceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bookFromList(_ sender: UIButton) {
        
        Constants.Globals.hosName = hospitalName.text!

    }
    
}
