//
//  bloodShortageViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 11/07/1443 AH.
//
import UIKit
import FirebaseFirestore

protocol BloodShortageDelegate : AnyObject{
    
    func onBloodUpdateCompletion(toastType : String)
    
}

class updateBloodShortageVC: UIViewController {
    
    // when pressing the save btn save data to blood shortage collection as Int
    // ( so don't forget to cast it ) + save it to total blood shortage
    //
 
    var bloodTypeArray = [bloodTypeAndValue]()
    var oldBloodTypeArray = [bloodTypeAndValue]()
    
    weak var delegate: BloodShortageDelegate!
    var passOrFail : String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bloodShortageNeed: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var saveBtnText: UIButton!
    
    @IBOutlet weak var cancelBtnText: UIButton!
    @IBAction func cancelBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBloodShBtn(_ sender: UIButton) {
        // delete it

        // write code to get the first doc of bloodshortage 
        // change the uid of doc to current user
        let userRef = db.collection(const.FStore.hospitalCollection).document("0F3Wi195PeBbeQuZKpNt")
           
           userRef.updateData([
            // 0 >> A+ , 1 >> A-,  2 >> B+, 3 >> B-
            // 4 >> O+ , 5 >> O-,  6 >> AB+, 7 >> AB-
            "bloodShortage.A_pos" : bloodTypeArray[0].value,
            "bloodShortage.B_pos" : bloodTypeArray[2].value,
            "bloodShortage.O_pos" : bloodTypeArray[4].value,
            "bloodShortage.AB_pos" : bloodTypeArray[6].value,
                                  
            "bloodShortage.A_neg" : bloodTypeArray[1].value,
            "bloodShortage.B_neg"  : bloodTypeArray[3].value,
            "bloodShortage.O_neg"  : bloodTypeArray[5].value,
            "bloodShortage.AB_neg"  : bloodTypeArray[7].value
           
           ]) { (error) in
               if error == nil {
                   print("blood shortage updated")
                self.passOrFail = "pass"
               }else{
                print("couldn't update blood shortage\(String(describing: error))")
                self.passOrFail = "fail"
               }
               
           }
        
        getTotalBloodShortage (completion: { totalBloodShortage in
            if let TBS = totalBloodShortage {
                self.ubdateTotalBloodShortage(totalObj: TBS)
            }})


        self.dismiss(animated: true, completion: { self.delegate?.onBloodUpdateCompletion(toastType: self.passOrFail! ) })
    
    
    }
    

    
    override func viewDidLoad() {
       // tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: const.cellNibName, bundle: nil), forCellReuseIdentifier: const.cellIdentifier)
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let customFontReg = UIFont(name: "Tajawal-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        // font style for blood
        bloodShortageNeed.font = UIFontMetrics.default.scaledFont(for: customFont)
        bloodShortageNeed.adjustsFontForContentSizeCategory = true
        bloodShortageNeed.font = bloodShortageNeed.font.withSize(24)
        
        unit.font = UIFontMetrics.default.scaledFont(for: customFontReg)
        unit.adjustsFontForContentSizeCategory = true
        unit.font = unit.font.withSize(14)
        
        saveBtnText.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 18)
        cancelBtnText.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 18)
        
      
    }
    
   func getTotalBloodShortage (completion: @escaping (totalBloodShortage?)->()){
    
    // first get the total so you can add the update to them
    let docRef = db.collection(const.FStore.hospitalCollection).document(const.FStore.totalBloodShDoc)
    
    docRef.getDocument { (document, error) in
        guard let document = document, document.exists else {
            print("Document does not exist, there was an issue fetching total blood shortage from firestore. ")
            return
        }
        let dataDescription = document.data()
     
        
     let totalBloodShort = totalBloodShortage(
         aPos: dataDescription![const.FStore.aPos] as! Int,
         aNeg: dataDescription![const.FStore.aNeg] as! Int,
         
         oPos: dataDescription![const.FStore.oPos] as! Int,
         oNeg: dataDescription![const.FStore.oNeg] as! Int,
         
         bPos: dataDescription![const.FStore.bPos] as! Int,
         bNeg: dataDescription![const.FStore.bNeg] as! Int,
         
         abPos: dataDescription![const.FStore.abPos] as! Int,
         abNeg: dataDescription![const.FStore.abNeg] as! Int)
     
        
        
        
        
        
     
     completion(totalBloodShort)
    }
    
    // end
   }
    
    
    func ubdateTotalBloodShortage(totalObj :totalBloodShortage){
        
        // new - old
        // 70 - 60 =10
        // 60 - 70 = -10
      
        if self.oldBloodTypeArray[0].value != nil {
            let aPos = totalObj.aPos + (self.bloodTypeArray[0].value - self.oldBloodTypeArray[0].value)
            let bPos = totalObj.bPos + (self.bloodTypeArray[2].value - self.oldBloodTypeArray[2].value)
            let oPos = totalObj.oPos + (self.bloodTypeArray[4].value - self.oldBloodTypeArray[4].value)
            let abPos = totalObj.abPos + (self.bloodTypeArray[6].value - self.oldBloodTypeArray[6].value)
        
            let aNeg = totalObj.aNeg + (self.bloodTypeArray[1].value - self.oldBloodTypeArray[1].value)
            let bNeg = totalObj.bNeg + (self.bloodTypeArray[3].value - self.oldBloodTypeArray[3].value)
            let oNeg = totalObj.oNeg + (self.bloodTypeArray[5].value - self.oldBloodTypeArray[5].value)
            let abNeg = totalObj.abNeg + (self.bloodTypeArray[7].value - self.oldBloodTypeArray[7].value)
        
    
    // we update the total in firestore
            let docRef = self.db.collection(const.FStore.hospitalCollection).document(const.FStore.totalBloodShDoc)
            
        docRef.updateData([
                     
                     const.FStore.aPos : aPos,
                     const.FStore.bPos : bPos,
                     const.FStore.oPos : oPos,
                     const.FStore.abPos : abPos,
                               
                     const.FStore.aNeg : aNeg,
                     const.FStore.bNeg : bNeg,
                     const.FStore.oNeg : oNeg,
                     const.FStore.abNeg : abNeg
        
        ])
    { (error) in
            if error == nil {
                print("total blood shortage updated")
                
                self.passOrFail = "pass"

            }else{
             print("couldn't update total blood shortage\(String(describing: error))")
                
                self.passOrFail = "fail"
            }
        }
        }else {
            print("in else")
            
        }
    }

  
} // end of class





// all the class is updated
extension updateBloodShortageVC : UITableViewDataSource {
    
    
    // num of cells - updated
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print (bloodValues.count)
       // return bloodValues.count
        
        return bloodTypeArray.count
    }
    

     // position - done updated
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: const.cellIdentifier, for: indexPath) as! bloodTypeCell
        
       // cell.bloodTypeLbl?.text = Array(bloodValues)[indexPath.row].key
       // cell.bloodTypeValue?.text = String(Array(bloodValues)[indexPath.row].value!) // must be updated whenever user click the btn
        
        cell.bloodTypeLbl?.text = bloodTypeArray[indexPath.row].bloodType
        cell.bloodTypeValue?.text = String(bloodTypeArray[indexPath.row].value)
        
        
        cell.decreaseBtn.tag = indexPath.row
        cell.increaseBtn.tag = indexPath.row
        
        cell.decreaseBtn.addTarget(self, action: #selector(decreaseValue(sender:)), for: .touchUpInside)
        cell.increaseBtn.addTarget(self, action: #selector(increaseValue(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc // updated
    func decreaseValue(sender: UIButton){
        
        // when button with tag # is clicked decrease lblValue with tag #
        
        if bloodTypeArray[sender.tag].value == 0{
            return
            
        }
        
        let val = bloodTypeArray[sender.tag].value-1
        
        self.bloodTypeArray[sender.tag].value = val
        self.tableView.reloadData()
        
        
        
    }
    
    
    @objc // updated
    func increaseValue( sender: UIButton){
        
        // when button with tag # is clicked increase lblValue with tag #
        

        let val = bloodTypeArray[sender.tag].value+1
        
        self.bloodTypeArray[sender.tag].value = val
        self.tableView.reloadData()
        
        
    }
    
}
  


