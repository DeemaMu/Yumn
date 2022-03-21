//
//  VOCollectionViewCell.swift
//  Yumn
//
//  Created by Deema Almutairi on 19/03/2022.
//

import Foundation
import UIKit
class VOCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var des: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var edit: UIButton!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
}
