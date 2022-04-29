//
//  BloodDonationAppointmentViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/04/2022.
//

import UIKit


class BloodDonationAppointmentViewController: UIViewController {
    @IBOutlet weak var dateTableView: UITableView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var calendarBtn: UIButton!
    
    

    @IBOutlet weak var continueBtn: UIButton!
    

    @IBOutlet weak var timeTableView: UITableView!
    
    
  
    @IBOutlet weak var roundView: UIView!
    
    override func viewDidLoad() {
        
        roundView.layer.cornerRadius = 35
        
        continueBtn.layer.cornerRadius = 25
        dateTableView.transform = CGAffineTransform (rotationAngle: 1.5707963)
        
        
        dateTableView.dataSource = self
        timeTableView.dataSource = self
        
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
     
        
        dateTableView.register(UINib(nibName: "dateCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        
        timeTableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")

        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onPressedContinueBtn(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onPressedCalendarBtn(_ sender: Any) {
    }
}







extension BloodDonationAppointmentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //date
        if (tableView == dateTableView){
            return 10}
        
        //time
        else{
            
            return 10
        }
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 300.3
    }*/
    
    
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0//Choose your custom row height
    }*/

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?

        
        if (tableView == dateTableView){
         cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        }
        
        
        // Time cell
        else{
            
             cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
        }
        return cell!

        
       
        
        
 
        
        

    
}
    }
