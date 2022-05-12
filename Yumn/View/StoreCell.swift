//
//  StoreCell.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/05/2022.
//

import UIKit


class StoreCell: UITableViewCell {
    
    

    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var storeImage: UIImageView!
    
    
  
    @IBOutlet weak var instagramBtn: UIButton!
    
    var instagram = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        // Initialization code
        
        storeImage.layer.cornerRadius = 32
        
        whiteView.layer.cornerRadius = 15
    
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 6)
        whiteView.layer.shadowColor = UIColor.gray.cgColor
        whiteView.layer.shadowRadius = 6
        whiteView.layer.shadowOpacity = 0.1
        whiteView.layer.shadowRadius = 15
        whiteView.layer.masksToBounds = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPressedInstagramBtn(_ sender: Any) {
        
        let Username =  instagram
        
           let appURL = URL(string: "instagram://user?username=\(Username)")!
           let application = UIApplication.shared

           if application.canOpenURL(appURL) {
               application.open(appURL)
           } else {
               // if Instagram app is not installed, open URL inside Safari
               let webURL = URL(string: "https://instagram.com/\(Username)")!
               application.open(webURL)
           }

        
    }
    
    
}
