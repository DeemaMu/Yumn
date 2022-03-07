//
//  customTabBar.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 14/07/1443 AH.
//

import UIKit

@IBDesignable
class customTabBarVC: UITabBarController, UITabBarControllerDelegate {
   
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        if self.restorationIdentifier == "hospitalHome" {
            
        self.selectedIndex = 0 // make it 0 so it starts at shortage in hospital home
            
        }
        
        else {
            
            self.selectedIndex = 1
        }
        UITabBar.appearance().barTintColor =  UIColor.white

        /*
               let controller1 = UIViewController()
               controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
               let nav1 = UINavigationController(rootViewController: controller1)

               let controller2 = UIViewController()
               let nav2 = UINavigationController(rootViewController: controller2)
        nav2.title = ""
        
               let controller3 = UIViewController()
               controller3.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
               let nav3 = UINavigationController(rootViewController: controller3)

               viewControllers = [nav1, nav2, nav3]
         */
        setupMiddleButton()
        
    }
    
    
    
    
    
    
    func setupMiddleButton() {
           let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 46, y: -30, width: 92, height: 70)) // width: 70 for v
           
        
        if self.restorationIdentifier == "hospitalHome" {
        
        
           middleButton.setBackgroundImage(UIImage(named: "calendarHome"), for: .normal)
            
        }
        
        else {
            
            print("volunteer home")

            middleButton.setBackgroundImage(UIImage(named: "home"), for: .normal)

        }
        
        
           middleButton.layer.shadowColor = UIColor.black.cgColor
           middleButton.layer.shadowOpacity = 0.1
           middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
           
        
           self.tabBar.addSubview(middleButton)
           middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
           
           self.view.layoutIfNeeded()
       }
       
       @objc func menuButtonAction(sender: UIButton) {
           self.selectedIndex = 1
       }
    
    

    
    
    
    
    
}
