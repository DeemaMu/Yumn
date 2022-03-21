//
//  ViewVOCollectionViewCell.swift
//  Yumn
//
//  Created by Deema Almutairi on 21/03/2022.
//

import Foundation
import UIKit
class ViewVOCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var des: UILabel!
    
    @IBOutlet weak var apply: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
}
