//
//  DonorCollectionViewCell.swift
//  Yumn
//
//  Created by Deema Almutairi on 22/04/2022.
//

import Foundation
import UIKit
class DonorCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var organs: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var bloodType: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
