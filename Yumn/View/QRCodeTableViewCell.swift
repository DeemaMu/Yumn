//
//  QRCodeTableViewCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/04/2022.
//

import UIKit


class QRCodeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var createdAt: UILabel!
    
    var id:String = ""
    
    @IBOutlet weak var viewQRCodeBtn: UIButton!

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func onPressedViewQr(_ sender: Any) {
    }
    
}
