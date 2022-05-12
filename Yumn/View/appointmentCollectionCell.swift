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
    @IBOutlet weak var inCompleteView: UITextView!
    @IBOutlet weak var completeView: UITextView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
