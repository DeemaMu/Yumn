//
//  BloodDonationViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 14/02/2022.
//

import UIKit
import SwiftUI

class BloodDonationViewController: UIViewController, CustomSegmentedControlDelegate {
    func change(to index: Int) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50), buttonTitle: ["مراكز التبرع","الإرشادات","الإحتياج"])
            codeSegmented.backgroundColor = .clear
        self.view.addSubview(codeSegmented)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//struct BloodDonationViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
