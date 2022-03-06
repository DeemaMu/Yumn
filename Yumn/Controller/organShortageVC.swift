//
//  organShortageVC.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 18/07/1443 AH.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth



protocol OrganShortageDelegate : AnyObject{
    
    func onOrganUpdateCompletion(toastType : String)
    
}



class updateOrganShortageVC: UIViewController {
    
    
    
    // when pressing the save btn save data to blood shortage collection as Int
    // ( so don't forget to cast it ) + save it to total blood shortage
    //
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var organShortageNeed: UILabel!
    
    @IBOutlet weak var cancelBtnText: UIButton!
    @IBOutlet weak var saveBtnText: UIButton!
    var timerForShowScrollIndicator: Timer?
    var organsArray = [organsAndValue]()
    var oldOrgansArray = [organsAndValue]()
    
    weak var delegate: OrganShortageDelegate!
    var passOrFail : String?
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    
    
    
    /// Show always scroll indicator in table view
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.000000000000000000000000001) {// 0.001
            self.tableView.flashScrollIndicators()
        }
    }

    /// Start timer for always show scroll indicator in table view
    @objc
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }

    /// Stop timer for always show scroll indicator in table view
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    
    
    override func viewDidLoad() {
       // tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: const.cellNibNameOrgans, bundle: nil), forCellReuseIdentifier: const.cellIDOrgans)
        startTimerForShowScrollIndicator()
        
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        organShortageNeed.font = UIFontMetrics.default.scaledFont(for: customFont)
        organShortageNeed.adjustsFontForContentSizeCategory = true
        organShortageNeed.font = organShortageNeed.font.withSize(24)
        
        saveBtnText.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 18)
        cancelBtnText.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 18)
      
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimerForShowScrollIndicator()
    }
    
    
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        // write code to get the first doc of bloodshortage
        // change the uid of doc to current user
        let userRef = db.collection(const.FStore.hospitalCollection).document(user!.uid)
           
           userRef.updateData([
            // 0 >> heart , 1 >> lung,  2 >> kidney, 3 >> liver
            // 4 >> intestine , 5 >> cornea,  6 >> pancreas, 7 >> boneMarrow
            "organShortage.heart" : organsArray[0].value,
            "organShortage.lung" : organsArray[1].value,
            "organShortage.kidney" : organsArray[2].value,
            "organShortage.liver" : organsArray[3].value,
                                  
            "organShortage.intestine" : organsArray[4].value,
            "organShortage.cornea"  : organsArray[5].value,
            "organShortage.pancreas"  : organsArray[6].value,
            "organShortage.boneMarrow"  : organsArray[7].value
           
           ]) { (error) in
               if error == nil {
                   print("organ shortage updated")
                
                self.passOrFail="pass"
               }else{
                print("couldn't update organ shortage\(String(describing: error))")
                self.passOrFail="fail"
               }
               
           }
        
        getTotalOrganShortage (completion: { totalOrganShort in
            if let TBS = totalOrganShort {
                self.ubdateTotalOrganShortage(totalObj: TBS)
            }})
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            
        self.dismiss(animated: true, completion: { self.delegate?.onOrganUpdateCompletion(toastType: self.passOrFail! ) })
            
        }
       // end of save button
        
    }
    
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
  
    
   func getTotalOrganShortage (completion: @escaping (totalOrganShortage?)->()){
    
    // first get the total so you can add the update to them
    let docRef = db.collection(const.FStore.hospitalCollection).document(const.FStore.totalOrganShDoc)
    
    docRef.getDocument { (document, error) in
        guard let document = document, document.exists else {
            print("Document does not exist, there was an issue fetching total organ shortage from firestore. ")
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
    
    // end
   }
    
    
    
    
    
    
    func ubdateTotalOrganShortage(totalObj :totalOrganShortage){
        
        // new - old
        // 70 - 60 =10
        // 60 - 70 = -10
        // 0 >> heart , 1 >> lung,  2 >> kidney, 3 >> liver
        // 4 >> intestine , 5 >> cornea,  6 >> pancreas, 7 >> boneMarrow
        if self.organsArray[0].value != nil {
            
            let heart = totalObj.heart + (self.organsArray[0].value - self.oldOrgansArray[0].value)
            let lung = totalObj.lung + (self.organsArray[1].value - self.oldOrgansArray[1].value)
            let kidney = totalObj.kidney + (self.organsArray[2].value - self.oldOrgansArray[2].value)
            let liver = totalObj.liver + (self.organsArray[3].value - self.oldOrgansArray[3].value)
        
            let intestine = totalObj.intestine + (self.organsArray[4].value - self.oldOrgansArray[4].value)
            let cornea = totalObj.cornea + (self.organsArray[5].value - self.oldOrgansArray[5].value)
            let pancreas = totalObj.pancreas + (self.organsArray[6].value - self.oldOrgansArray[6].value)
            let boneMarrow = totalObj.boneMarrow + (self.organsArray[7].value - self.oldOrgansArray[7].value)
        
    
    // we update the total in firestore
            let docRef = self.db.collection(const.FStore.hospitalCollection).document(const.FStore.totalOrganShDoc)
            
        docRef.updateData([
                     
                     const.FStore.heart : heart,
                     const.FStore.lung : lung,
                     const.FStore.kidney : kidney,
                     const.FStore.liver : liver,
                               
                     const.FStore.intestine : intestine,
                     const.FStore.cornea : cornea,
                     const.FStore.pancreas : pancreas,
                     const.FStore.boneMarrow : boneMarrow
        
        ])
    { (error) in
            if error == nil {
                print("total organ shortage updated")
                self.passOrFail = "pass"
            }else{
             print("couldn't update total organ shortage\(String(describing: error))")
                self.passOrFail = "fail"
            }
        }
        // dismiss pop up (rerurn to previous page)
        }else {
            print("in else")
        }
    //}
    }
    
    
} // end of class





// all the class is updated
extension updateOrganShortageVC : UITableViewDataSource {
    
    
    // num of cells - updated
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print (bloodValues.count)
       // return bloodValues.count
        
        return organsArray.count
    }
    
    
     // position - done updated
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: const.cellIDOrgans, for: indexPath) as! organCell
        
        cell.organ?.text = organsArray[indexPath.row].organ
        cell.organValue?.text = String(organsArray[indexPath.row].value)
        
        
        cell.decreaseBtn.tag = indexPath.row
        cell.increaseBtn.tag = indexPath.row
        
        cell.decreaseBtn.addTarget(self, action: #selector(decreaseValue(sender:)), for: .touchUpInside)
        cell.increaseBtn.addTarget(self, action: #selector(increaseValue(sender:)), for: .touchUpInside)
        
        
        cell.selectionStyle = .none

        return cell
    }
    
    @objc
    func decreaseValue(sender: UIButton){
        
        if organsArray[sender.tag].value == 0{
            return
            
        }
        
        let val = organsArray[sender.tag].value-1
        
        self.organsArray[sender.tag].value = val
        self.tableView.reloadData()
        
        
        
    }
    
    
    @objc
    func increaseValue( sender: UIButton){
        
        let val = organsArray[sender.tag].value+1
        
        self.organsArray[sender.tag].value = val
        self.tableView.reloadData()
        
        
    }
    
}
  


