//
//  RewardsViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 04/04/2022.
//

import UIKit

class RewardsViewController: UIViewController {
    @IBOutlet weak var pointsBox: UILabel!
    @IBOutlet weak var roundview: UIView!
    
    override func viewDidLoad() {
        
        roundview.layer.cornerRadius = 35
        pointsBox.layer.cornerRadius = 15

        navigationController?.navigationBar.barTintColor = UIColor.green

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
