//
//  BloodDonationAppointmentViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/04/2022.
//

import UIKit


class BloodDonationAppointmentViewController: UIViewController {
    @IBOutlet weak var dateTableView: UITableView!
    
  
    @IBOutlet weak var roundView: UIView!
    
    override func viewDidLoad() {
        
        roundView.layer.cornerRadius = 35
        
        
        dateTableView.transform = CGAffineTransform (rotationAngle: 1.5707963)
        
        
        dateTableView.dataSource = self
     
        
        dateTableView.register(UINib(nibName: "dateCell", bundle: nil), forCellReuseIdentifier: "DateCell")

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







extension BloodDonationAppointmentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 300.3
    }*/
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.transform = CGAffineTransform (rotationAngle:  CGFloat.pi)

      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0//Choose your custom row height
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        
        
        
        
        
        

        
       
        
      
       // print ("celllllllllll")
       // print (cell)
        
        
        return cell
        

    
}
    
    
   

}
