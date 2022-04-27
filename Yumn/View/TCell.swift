//
//  QRCodeTableViewCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/04/2022.
//

import UIKit


class TCell: UITableViewCell {
    
    
  
    @IBOutlet weak var label: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
