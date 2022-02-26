//
//  StackedViewsProvider.swift
//  Yumn
//
//  Created by Rawan Mohammed on 24/02/2022.
//
import UIKit

protocol StackedViewsProvider {
    var views: [UIView] { get }
}

class SegmentedControlStackedViewsProvider: StackedViewsProvider {
    let items = ["مراكز التبرع","الإرشادات","الإحتياج"]
    
    lazy var views: [UIView] = {
        return [
            createView(items: items)
        ]
    }()
    
    private func createView(items: [String]) -> UIView {
        let builder = SegmentedControlBuilder()
        return builder.makeSegmentedControl(items: items)
    }
}
