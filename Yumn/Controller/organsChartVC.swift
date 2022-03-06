//
//  bloodChartViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 12/07/1443 AH.
//

import UIKit
import FirebaseFirestore
import Charts

class organsChartVC: UIViewController, ChartViewDelegate {
    
    let db = Firestore.firestore()
    var pieChart = PieChartView()
    
    
    @IBOutlet weak var viewOrganPie: UIView!
    @IBOutlet weak var organDonation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        
       // getTotalBloodShortage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        organDonation.font = UIFontMetrics.default.scaledFont(for: customFont)
        organDonation.adjustsFontForContentSizeCategory = true
        organDonation.font = organDonation.font.withSize(28)
        
       
        // for rounded top corners (view)
        if #available(iOS 11.0, *) {
                self.viewOrganPie.clipsToBounds = true
            viewOrganPie.layer.cornerRadius = 35
            viewOrganPie.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        
        
        // show loading indicator when data is being fetched
      //  loadingIndicator()
        
        setUpChart()
        
        getTotalOrganShortage(completion: { totalOrganShortge in
            if let TOS = totalOrganShortge {
                
                self.populateChart(TOS: TOS)
                
            } else {
                //handle nil response
                print("couldn't build pie chart")
            }
        })
        
       
        
    }
    
    
    func getTotalOrganShortage( completion: @escaping (totalOrganShortage?)->())  {
   
        
        let docRef = db.collection(const.FStore.hospitalCollection).document(const.FStore.totalOrganShDoc)

        // Get data
               docRef.getDocument { (document, error) in
                   guard let document = document, document.exists else {
                       print("Document does not exist, there was an issue fetching total organs shortage from firestore. ")
                       return
                   }
                   let dataDescription = document.data()
                let totalOrganShort = totalOrganShortage(
                    heart: dataDescription![const.FStore.heart] as! Int,
                    lung: dataDescription![const.FStore.lung] as! Int,
                    kidney: dataDescription![const.FStore.kidney] as! Int,
                    liver: dataDescription![const.FStore.liver] as! Int,
                    pancreas: dataDescription![const.FStore.pancreas] as! Int,
                    intestine: dataDescription![const.FStore.intestine] as! Int,
                    cornea: dataDescription![const.FStore.cornea] as! Int,
                    boneMarrow: dataDescription![const.FStore.boneMarrow] as! Int)
                
                
                completion(totalOrganShort)
               }
    }
    
    
    func loadingIndicator(){
        
        pieChart.noDataText = "Loading"
        pieChart.noDataTextColor = .blue
        pieChart.noDataFont = UIFont(name: "Helvetica", size: 10.0)!
        
    }
    
    
    func setUpChart(){
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
    }
    
    
    
    
    func populateChart(TOS :  totalOrganShortage){
        
        
        
        let totalOSh : Int = TOS.heart + TOS.lung +
            TOS.liver + TOS.kidney +
            TOS.pancreas + TOS.cornea +
            TOS.intestine + TOS.boneMarrow
        
                        
        let heartPercentage : Int = TOS.heart
        let lungPercentage : Int = TOS.lung
        let kidneyPercentage : Int = TOS.kidney
        let liverPercentage : Int = TOS.liver
        
        let pancreasPercentage : Int = TOS.pancreas
        let intestinePercentage : Int = TOS.intestine
        let boneMarrowPercentage : Int = TOS.boneMarrow
        let corneaPercentage : Int = TOS.cornea
        
       
        
        let pieChartEntry: [PieChartDataEntry] = [
            
        
            PieChartDataEntry(value: Double((Double(heartPercentage)/Double(totalOSh))*100), label: "قلب"),
            PieChartDataEntry(value: Double((Double(lungPercentage)/Double(totalOSh))*100), label: "رئة"),
            PieChartDataEntry(value: Double((Double(kidneyPercentage)/Double(totalOSh))*100), label: "كلية"),
            PieChartDataEntry(value: Double((Double(liverPercentage)/Double(totalOSh))*100), label: "كبد"),
            
            
            PieChartDataEntry(value: Double((Double(pancreasPercentage)/Double(totalOSh))*100), label: "بنكرياس"),
            PieChartDataEntry(value: Double((Double(intestinePercentage)/Double(totalOSh))*100), label: "امعاء"),
            PieChartDataEntry(value: Double((Double(boneMarrowPercentage)/Double(totalOSh))*100), label: "نخاع العظم"),
            PieChartDataEntry(value: Double((Double(corneaPercentage)/Double(totalOSh))*100), label: "القرنية")
        ]
        
        let set = PieChartDataSet(entries: pieChartEntry)
        //set.colors = ChartColorTemplates.colorful()
        set.colors = [const.Colors.green, const.Colors.yellow, const.Colors.orange, const.Colors.pink, const.Colors.green, const.Colors.yellow, const.Colors.orange, const.Colors.pink]
        let data = PieChartData(dataSet: set)
        
        let pFormater = NumberFormatter()
        pFormater.numberStyle = .percent
        pFormater.maximumFractionDigits = 1
        pFormater.multiplier = 1
        pFormater.percentSymbol = "%"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormater))
        self.pieChart.data = data
        //self.pieChart.usePercentValueEnabled = true
       
        self.pieChart.legend.enabled=false
        /* let legend = self.pieChart.legend
         legend.horizontalAlignment = .center
         legend.verticalAlignment = .bottom
         legend.orientation = .horizontal*/
         // suppose to end here
       //  self.pieChart.data=data
    }
    
}
