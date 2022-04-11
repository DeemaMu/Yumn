//
//  QRCodeViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 11/04/2022.
//

import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
       
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.4
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5
        
        backgroundView.layer.cornerRadius = 30
        
        
        bottomImage.layer.cornerRadius = 25
        //self.bottomImage.clipsToBounds = true



        
        
        super.viewDidLoad()

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
