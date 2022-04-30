//
//  BloodDonationAppointmentViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/04/2022.
//

import UIKit
import Firebase


class BloodDonationAppointmentViewController: UIViewController {
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var noAvailableAppointment: UILabel!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var calendarBtn: UIButton!
    
    

    @IBOutlet weak var continueBtn: UIButton!
    

    @IBOutlet weak var timeTableView: UITableView!
    
    
    @IBOutlet weak var appointmentHospitalNameLabel: UILabel!
    

    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var popupstack: UIStackView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    var remainingDaysOfTheMonth:[DateCellInfo]?
    
    var sortedTimes:[BloodDonationTime]?

    
    
    override func viewDidLoad() {
        
       // blackBlurredView.isHidden = true
     //   popupView.isHidden = true
        
        popupView.layer.cornerRadius = 30
        
        confirmBtn.layer.cornerRadius = 20
        
        
        
      
        let db = Firestore.firestore()
        
        let docRef = db.collection("hospitalsInformation").document(Constants.Globals.hospitalId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
               
                    
                let hName = document.get("name") as! String
                    
                        
                self.hospitalNameLabel.text! = hName
                        
                    }
                 else {
                print("Document does not exist")
            }
        }
        
        
        self.remainingDaysOfTheMonth = getRemainingDaysOfTheMonth()
        
        
        //The first cell is selected by defualt
        self.remainingDaysOfTheMonth![0].selected = true

        
        noAvailableAppointment.superview?.bringSubviewToFront(noAvailableAppointment)


        
        roundView.layer.cornerRadius = 35
        
        continueBtn.layer.cornerRadius = 25
        dateTableView.transform = CGAffineTransform (rotationAngle: 1.5707963)
        
        
        dateTableView.dataSource = self
        timeTableView.dataSource = self
        
        dateTableView.register(UINib(nibName: "dateCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        
        timeTableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        

        
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //It includes the first selected cell
        Constants.Globals.appointmentDateArray = remainingDaysOfTheMonth
       
        self.sortedTimes = getAvailableAppointmentsTimes()
        
     

        Constants.Globals.appointmentTimeArray = getAvailableAppointmentsTimes()
        
       

        
        let indexPath = IndexPath(row: 0, section: 0)
            dateTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        

        
            timeTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
       /*
        if (Constants.Globals.appointmentTimeArray!.count == 0){
            
            timeTableView.isHidden = true
            noAvailableAppointment.isHidden = false
            
        }*/
        
        
        super.viewDidLoad()
        
                
        
        
        //setInitialViewToCurrentMonth()
        
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onPressedContinueBtn(_ sender: Any) {
        
        
        popupView.isHidden = false
        blackBlurredView.isHidden = false
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
    
    
    
    
    func getAppointmentsofTheDay (day: Date){
        
        
        
        
        
        
    }
    
    
    @IBAction func onPressedConfirmAppointment(_ sender: Any) {
    }
    
    @IBAction func onPressedCancel(_ sender: Any) {
        
        popupView.isHidden = true
        blackBlurredView.isHidden = true
    }
}







extension BloodDonationAppointmentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //date
        if (tableView == dateTableView){
            
            //We Should check if the date is changed
            
            
            return self.remainingDaysOfTheMonth!.count}
        
        //time
        else{
            
            return sortedTimes!.count
        }
    }
    
   


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (tableView == dateTableView){
            
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            
          
            dateCell.dateLabel.text! =  remainingDaysOfTheMonth![indexPath.row].dateNum
    
            
            
            
            dateCell.dayLabel.text! =  remainingDaysOfTheMonth![indexPath.row].day
            
            dateCell.index = indexPath.row
            
           
            
           
            
            print (dateCell.isChosen)
            
            return dateCell
            
            
            
            
            
            
        }
        
        
        // Time cell
        else{
            
            let timeCell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
    

            timeCell.timeSlotLabel.text! =  sortedTimes![indexPath.row].startTime + " - " + sortedTimes![indexPath.row].endTime
            
            timeCell.index = indexPath.row
            
            print (indexPath.row)

            
       
            
            
            return timeCell
        }

  
}
    
 
    
    func setInitialViewToCurrentMonth(){
        
        
                
    
       
        
        
    }

    
    
    
    func getRemainingDaysOfTheMonth() -> [DateCellInfo]
    {
        var datesArray:[DateCellInfo] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"

        
        
        let lastDayOfCurrentMonthDate = Date().endOfMonth
        
        let currentDayOfCurrentMonthDate = Date()
        
        let lastDayOfCurrentMonthString = (formatter.string(from: lastDayOfCurrentMonthDate)).prefix(2)
        
        let currentDayOfCurrentMonthString = (formatter.string(from: currentDayOfCurrentMonthDate)).prefix(2)
        
        var currentDate = Date()

        
        print (lastDayOfCurrentMonthString)
        print(currentDayOfCurrentMonthString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        while currentDate <= lastDayOfCurrentMonthDate {
            
            datesArray.append(DateCellInfo(day: dateFormatter.string(from: currentDate)
           , dateNum: String((formatter.string(from: currentDate)).prefix(2)), date: currentDate))
            
                currentDate = nextDay(date:currentDate)
            }
        
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "m"
        var monthAndYear = Date().month
        dateFormatter2.dateFormat = "yyyy"
        monthAndYear += "، " + dateFormatter2.string(from: Date())
        
        
        
        monthLabel.text = monthAndYear

        
        
        print (datesArray)
        
        
        return (datesArray)

        

        
        
    }
    func nextDay(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        return Calendar.current.date(byAdding: dateComponents, to: date)!
    }

}







// Date
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var month: String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM"
           return dateFormatter.string(from: self)
       }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
