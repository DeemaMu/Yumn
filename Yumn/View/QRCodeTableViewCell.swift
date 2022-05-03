//
//  QRCodeTableViewCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/04/2022.
//

import UIKit
import Foundation


class QRCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var viewQRCodeBtn: UIButton!
  
    @IBOutlet weak var createdAt: UILabel!
    
    
    var id:String = ""
    
   

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        
        viewQRCodeBtn.layer.cornerRadius = 25
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func onPressedViewQr(_ sender: Any) {
        
     
        
        
        Constants.Globals.newQR = false
        Constants.Globals.currentQRID = id
        
        
    }
    
    
    
    
    
    
    
}
