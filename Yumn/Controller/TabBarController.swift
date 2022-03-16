//
//  TabBarController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 24/02/2022.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {

   override func viewDidLoad() {
       super.viewDidLoad()
       self.selectedIndex = 1
       self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 10)
       self.tabBar.layer.shadowRadius = 10
       self.tabBar.layer.shadowColor = #colorLiteral(red: 0.504814744, green: 0.5049032569, blue: 0.5048031211, alpha: 1)
       self.tabBar.layer.shadowOpacity = 0.8
       

   }

}
