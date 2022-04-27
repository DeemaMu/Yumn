//
//  appointmentCollectionCell.swift
//  Yumn
//
//  Created by Deema Almutairi on 27/04/2022.
//

import Foundation
import UIKit
class appointmentCollectionCell : UICollectionViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var donor: UILabel!
    
    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var incomplete: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
