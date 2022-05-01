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
    
    var selectedApp:String = ""
    
    var selecetedOuterDocId:String = ""

    
    
    
    
    var appointmentDuration:Int = 0
    var hospitalName:String = ""
    var hospitalCity:String = ""
    var hospitalArea:String = ""
    var appointmentdate:Timestamp = Timestamp()
    var startTime:Timestamp = Timestamp()

    var endTime: Timestamp = Timestamp()
    
    var longitude = 0.0
    var latitude = 0.0

    
    func updateTable(){
        
        DispatchQueue.main.async {
            self.timeTableView.reloadData()
        }

    }
    
    
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        
       // blackBlurredView.isHidden = true
     //   popupView.isHidden = true
        
        popupView.layer.cornerRadius = 30
        
        confirmBtn.layer.cornerRadius = 20
        
       

        
        
        
      
        
        let docRef = db.collection("hospitalsInformation").document(Constants.Globals.hospitalId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
               
                    
                let hName = document.get("name") as! String
                    
                        
                self.hospitalNameLabel.text! = hName
                self.appointmentHospitalNameLabel.text = "مركز التبرع بالدم - " + hName
                        
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
        
       // dateTableView.addTarget(self, action: #selector(setTimeTable()), for: .editingChanged)
        
        
        
        super.viewDidLoad()
        
                
        
        
        //setInitialViewToCurrentMonth()
        
        
        

        // Do any additional setup after loading the view.
    }
    
   

    
  
   
    
    
    @IBAction func onPressedContinueBtn(_ sender: Any) {
        
        
        var selectedTimeSlot = false
        
        var hospital = ""
        
        
        var date:Date?
        
        let dateformat = DateFormatter()
               dateformat.dateFormat = "EEEE, MMM d, yyyy"
        
        for item in Constants.Globals.appointmentTimeArray!{
            
            if (item.selected == true){
                
                selectedTimeSlot = true
                selectedApp = item.appointmentID
                selecetedOuterDocId = item.outerDocId
                
                
                
                
               
                
                self.appointmentTimeLabel.text = item.startTime + " - " + item.endTime
                
                self.appointmentDateLabel.text = dateformat.string(from: item.appDate!)

                
           
             
                
                
                
                
                
                print ("selected appointment " + selectedApp)
            }
        }
        
        if (!selectedTimeSlot){
            
            
            //Show toast
            
            self.showToast(message: "الرجاء اختيار وقت للموعد", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))
}
            
            
        
        
        
        else{
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        }
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
        
        //The user's id using auth (after integration)
        let volunteerId = "iDhMoT6PacOwKgKLi8ILK98UrB03"

        
        
        // Change booked to true and donor to the volunteer id
        
        
        
        db.collection("appointments").document(selecetedOuterDocId).collection("appointments").document(selectedApp).updateData([
            "booked": true,
            "donor": volunteerId
            
            
            ]){ error in
        
            if error != nil {
                
                print(error?.localizedDescription as Any)
                
                print ("error in updating booked attribute")
                
                self.showToast(message: "حدث خطأ ما يرجى المحاولة لاحقا", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))
            }
       }
        
        // Add the appointment id to the array
        
        db.collection("appointments").document(selecetedOuterDocId).updateData([
            "bookedAppointments": FieldValue.arrayUnion([selectedApp]),
        
            
        ]){ error in
    
        if error != nil {
            
            print(error?.localizedDescription as Any)
            
            print ("error in adding the appointment id to the array")
            
            self.showToast(message: "حدث خطأ ما يرجى المحاولة لاحقا", font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))
        }
   }
        
                
        // The needed information for the blood appointment in the volunteer collection
        let dateformat = DateFormatter()
               dateformat.dateFormat = "MM/dd/yyyy"
        
        let timeFormat = DateFormatter()
               dateformat.dateFormat = "HH:mm"

        
        db.collection("volunteer").document(volunteerId).collection("bloodAppointments").document(selectedApp).setData([
            
           
            "appDateAndTime": self.startTime,
            "appID": self.selectedApp,
            "area":self.hospitalArea,
            "city": self.hospitalCity,
            "date": "",
            "hospitalID":Constants.Globals.hospitalId,
            "hospitalName":
                Constants.Globals.hosName,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "mainDocID": self.selecetedOuterDocId,
            "time": "",
       
        
        ])
        
        { error in
        
            if error != nil {
                
                print(error?.localizedDescription as Any)
                
            // Show error message or pop up message

                
                print ("error in saving the user data")
                
                
            }
            
        }
        
        
        /*
        // Info from the outer appointment collection
        db.collection("appointments").document(selecetedOuterDocId).getDocument { (document, error) in
            if let document = document, document.exists {
                
                
                self.appointmentDuration = (document.get("appointment_duration") as! Int)
                
                self.db.collection("volunteer").document(volunteerId).collection("bloodAppointments").document(self.selectedApp).updateData([
                    "appointment_duration": self.appointmentDuration,
                 
                    ])
                
                
                
                
            }
                    
                else{
                    print (error?.localizedDescription as Any)
                    
                }
            
        }
             */
        
        
        
        
      // Info from the hospitalInformation collection
            
        db.collection("hospitalsInformation").document(Constants.Globals.hospitalId).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    self.hospitalName = (document.get("name") as! String)
                    
                    Constants.Globals.hosName = (document.get("name") as! String)
                    
                    print ("hospital name" + self.hospitalName)
                    
                    print ("hospital name global" + Constants.Globals.hosName)

                    
                    
                    
                    self.hospitalCity = (document.get("city") as! String)
                    self.hospitalArea = (document.get("area") as! String)
                    
                    self.longitude = (document.get("longitude") as! Double)
                    
                    self.latitude = (document.get("latitude") as! Double)
                    

                   
                    
                    
                    self.db.collection("volunteer").document(volunteerId).collection("bloodAppointments").document(self.selectedApp).updateData([
                        "hospitalName": self.hospitalName,
                        "area":self.hospitalArea,
                        "city": self.hospitalCity,
                        "longitude": self.longitude,
                        "latitude": self.latitude
                        
                        ])

                    
                    
                    
                   
                

                    
                    
                }
                        
                    else{
                        print (error?.localizedDescription as Any)
                        
                    }
            }
        
        
        //Info from the inner appointment collection
        
       
        
        
        db.collection("appointments").document(selecetedOuterDocId).collection("appointments").document(selectedApp).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    self.startTime = (document.get("start_time") as! Timestamp)
                    
                    self.endTime = (document.get("end_time") as! Timestamp)
                    
                    let timeFormat = DateFormatter()
                           timeFormat.dateFormat = "HH:mm"
                    
                    let timeString = timeFormat.string(from: self.startTime.dateValue())
                    
                    let dateformat = DateFormatter()
                           dateformat.dateFormat = "yyyy/MM/dd"
                    
                    let dateString = dateformat.string(from: self.startTime.dateValue())

                    
                    self.db.collection("volunteer").document(volunteerId).collection("bloodAppointments").document(self.selectedApp).updateData([
                        "time": timeString,
                        "date": dateString,
                        "appDateAndTime": self.startTime,
                        
                        ])
                    
                    
                    
                   
                    
                }
                        
                    else{
                        print (error?.localizedDescription as Any)
                        
                    }
            }
        
        
        
        
     
       
        
        
        
        popupView.layer.isHidden = true
        
        blackBlurredView.layer.isHidden = true
            
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
            
            
           // self.sortedTimes = getAvailableAppointmentsTimes()
            
         

     

            
            
            
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
            
         //   self.sortedTimes = getAvailableAppointmentsTimes()
            
         

        

            
            let timeCell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
    

            timeCell.timeSlotLabel.text! =  sortedTimes![indexPath.row].startTime + " - " + sortedTimes![indexPath.row].endTime
            
            timeCell.index = indexPath.row
            
            print (indexPath.row)

            
       
            
            
            return timeCell
        }

  
}
    
 
    
    func setTimeTable(){
        
        
        self.sortedTimes = getAvailableAppointmentsTimes()
        
        
            
        
        
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

    func currentTimeMillis() -> Int64 {
            return Int64(self.timeIntervalSince1970 * 1000)
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


