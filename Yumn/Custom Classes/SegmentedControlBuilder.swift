//
//  SegmentedControlBuilder.swift
//  Yumn
//
//  Created by Rawan Mohammed on 24/02/2022.
//

import Foundation
import UIKit

struct SegmentedControlBuilder {
    var boldStates: [UIControl.State] = [.selected, .highlighted]
    var boldFont = UIFont.boldSystemFont(ofSize: 14)
    var tintColor = UIColor.white
    var apportionsSegmentWidthsByContent = true
    
    func makeSegmentedControl(items: [String]) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)

        segmentedControl.apportionsSegmentWidthsByContent = apportionsSegmentWidthsByContent
        segmentedControl.tintColor = tintColor
        segmentedControl.selectedSegmentIndex = 0

        boldStates
            .forEach { (state: UIControl.State) in
                let attributes = [NSAttributedString.Key.font: boldFont]
                segmentedControl.setTitleTextAttributes(attributes, for: state)
        }
        
        return segmentedControl
    }
}
