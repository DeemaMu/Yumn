//
//  BloodDonationViewController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 10/02/2022.
//

import UIKit
import SwiftUI
//import BetterSegmentedControl
import MapKit
import CoreLocation
import Firebase
import FirebaseFirestore
import Charts

class OrganDonationViewController: UIViewController, CustomSegmentedControlDelegate, ChartViewDelegate {
    
    @IBOutlet weak var organBtn2: UIButton!
    @IBOutlet weak var arrow2: UIButton!
    @IBOutlet weak var organBtn1: UIButton!
    @IBOutlet weak var arrow1: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var organDonImage: UIImageView!
    @IBOutlet weak var organsStack1: UIStackView!
    @IBOutlet weak var organsStack2: UIStackView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    // by Modhi
    @IBOutlet weak var organPieWholeContainer: UIView!
    
    @IBOutlet weak var loadingGif: UIImageView!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var cityOfUser: UILabel!
    @IBOutlet weak var viewOrganPie: UIView!
    var pieChart = PieChartView()
    // var location:CLLocation?
   // var userLocation:CLLocationCoordinate2D?
 //   @IBOutlet weak var seg2: UIView!
    
    
    var codeSegmented:CustomSegmentedControl? = nil
    @IBOutlet weak var segmentsView: UIView!
    
    @IBOutlet weak var roundView: UIView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        //Organ Donation Information
        label1.text = "يمكن التبرع بـ:"
        label2.text = "- جزء من الكبد"
        label3.text = "- إحدى الكليتين"
        arrow1.contentHorizontalAlignment = .left
        arrow2.contentHorizontalAlignment = .left
        organBtn1.contentHorizontalAlignment = .right
        organBtn2.contentHorizontalAlignment = .right
        organDonImage.superview?.bringSubviewToFront(organDonImage)
        stackView.superview?.bringSubviewToFront(stackView)
        organsStack1.clipsToBounds = true
        organsStack2.clipsToBounds = true
        organsStack1.isHidden = true
        organsStack2.isHidden = true
        organDonImage.isHidden = true
        stackView.isHidden = true
        

        // by modhi
        pieChart.delegate = self
        organPieWholeContainer.isHidden = false
        viewOrganPie.isHidden = false
        cityOfUser.isHidden = false
        
        // for loading gif
        loadingGif.superview?.bringSubviewToFront(loadingGif)
        loadingGif.loadGif(name: "yumnLoading")
        // Blur the background
        blurredView.isHidden = false
        // Show Loading indicator
        loadingGif.isHidden = false
        
        super.viewDidLoad()
        
        
        
        //        print("\(String(describing: userLocation))")
        //        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0,width: seg2.frame.width,        height: 50.0))
        //        let control = BetterSegmentedControl.init(frame: CGRect(x: 0, y: 0, width:                    seg2.frame.width, height: 50), segments: , index: , options: )
        
        //        segmentedControl.selectedSegmentIndex = 2
        //        segmentedControl.removeBorder()
        //        segmentedControl.addUnderlineForSelectedSegment()
        //
        
        codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["نوع التبرع","الإرشادات","الإحتياج"])
        codeSegmented!.backgroundColor = .clear
        //        codeSegmented.delegate?.change(to: 2)
        segmentsView.addSubview(codeSegmented!)
        codeSegmented?.delegate = self
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if(index==0){
            
            organDonImage.isHidden = true
            stackView.isHidden = true
            organPieWholeContainer.isHidden = true
            viewOrganPie.isHidden = true
            cityOfUser.isHidden = true
            
            
        }
        else if(index == 1){
            
            organDonImage.isHidden = false
            stackView.isHidden = false
            organPieWholeContainer.isHidden = true
            viewOrganPie.isHidden = true
            cityOfUser.isHidden = true
        }
        
        else {
            
            organDonImage.isHidden = true
            stackView.isHidden = true
            organPieWholeContainer.isHidden = false
            viewOrganPie.isHidden = false
            cityOfUser.isHidden = false
        }
    }
    
    
    
    @IBAction func onPressedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    //Organ Donation Information
    @IBAction func onPressedArrow1(_ sender: Any) {
        
        organsStack1.isHidden = !organsStack1.isHidden
       
       if (organsStack1.isHidden == false){
        arrow1.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow1.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }

    }
    
    @IBAction func onPressedOrganBtn1(_ sender: Any) {
        
        organsStack1.isHidden = !organsStack1.isHidden
       
       if (organsStack1.isHidden == false){
        arrow1.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow1.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    
    
    @IBAction func onPressedOrganBtn2(_ sender: Any) {
        organsStack2.isHidden = !organsStack2.isHidden
       
       if (organsStack2.isHidden == false){
        arrow2.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow2.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    @IBAction func onPressedArrow2(_ sender: Any) {
        
        organsStack2.isHidden = !organsStack2.isHidden
       
       if (organsStack2.isHidden == false){
        arrow2.setImage(UIImage(systemName: "chevron.up"), for: .normal)
       }
       
       else{
           arrow2.setImage(UIImage(systemName: "chevron.down"), for: .normal)

       }
    }
    
    // by Modhi
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        

        guard let customFont2 = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        

        
        // updated
        cityOfUser.font = UIFontMetrics.default.scaledFont(for: customFont2)
        cityOfUser.adjustsFontForContentSizeCategory = true
        cityOfUser.font = cityOfUser.font.withSize(24)

        
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
                
                self.blurredView.isHidden = true
                // Show Loading indicator
                self.loadingGif.isHidden = true
                
                self.populateChart(TOS: TOS)
                
            } else {
                //handle nil response
                print("couldn't build pie chart")
            }
        })
        
       
        
    }
    
    
    
    
    func getTotalOrganShortage( completion: @escaping (totalOrganShortage?)->())  {
   
        // change the collection
        cityOfUser.text = "رسم بياني لاحتياج الأعضاء في المملكة"
        let docRef = db.collection("hospital").document(Constants.FStore.totalOrganShDoc)

        // Get data
               docRef.getDocument { (document, error) in
                   guard let document = document, document.exists else {
                       print("Document does not exist, there was an issue fetching total organs shortage from firestore. ")
                       return
                   }
                   let dataDescription = document.data()
                let totalOrganShort = totalOrganShortage(
                    heart: dataDescription![Constants.FStore.heart] as! Int,
                    lung: dataDescription![Constants.FStore.lung] as! Int,
                    kidney: dataDescription![Constants.FStore.kidney] as! Int,
                    liver: dataDescription![Constants.FStore.liver] as! Int,
                    pancreas: dataDescription![Constants.FStore.pancreas] as! Int,
                    intestine: dataDescription![Constants.FStore.intestine] as! Int,
                    cornea: dataDescription![Constants.FStore.cornea] as! Int,
                    boneMarrow: dataDescription![Constants.FStore.boneMarrow] as! Int)
                
                
                completion(totalOrganShort)
               }
    }
    
    
    func setUpChart(){
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.organPieWholeContainer.frame.size.width,
                                height: self.organPieWholeContainer.frame.size.width)
        
       // pieChart.center = organPieWholeContainer.center
        
        viewOrganPie.addSubview(pieChart)
     //   view.addSubview(pieChart)
        
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
        set.colors = [Constants.Colors.green, Constants.Colors.yellow, Constants.Colors.orange, Constants.Colors.pink, Constants.Colors.green, Constants.Colors.yellow, Constants.Colors.orange, Constants.Colors.pink]
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
    
    } // end of class

    

    
    



