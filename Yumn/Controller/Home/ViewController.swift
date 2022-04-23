//
//  ViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 07/07/1443 AH.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import ContextMenuSwift
class HospitalHomeMainViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!


    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    //    @IBOutlet weak var shortageNeed: UILabel!
    @IBOutlet weak var bloodShortageNeed: UILabel!
    
    @IBOutlet weak var organShortageNeed: UILabel!
    @IBOutlet weak var bloodUpdateBtn: UIButton!
    
    @IBOutlet weak var organUpdateBtn: UIButton!
    @IBOutlet weak var abNegative: UILabel!
    @IBOutlet weak var abPositive: UILabel!
    @IBOutlet weak var bNegative: UILabel!
    @IBOutlet weak var bPositive: UILabel!
    @IBOutlet weak var oNegative: UILabel!
    @IBOutlet weak var oPositive: UILabel!
    @IBOutlet weak var aNegative: UILabel!
    @IBOutlet weak var aPositive: UILabel!
    
    
    @IBOutlet weak var heart: UILabel!
    @IBOutlet weak var lung: UILabel!
    @IBOutlet weak var liver: UILabel!
    @IBOutlet weak var cornea: UILabel!
    @IBOutlet weak var boneMarrow: UILabel!
    @IBOutlet weak var pancreas: UILabel!
    @IBOutlet weak var intestine: UILabel!
    @IBOutlet weak var kidney: UILabel!
    
    
    @IBOutlet weak var heartLb: UILabel!
    @IBOutlet weak var lungLb: UILabel!
    @IBOutlet weak var kidneyLb: UILabel!
    @IBOutlet weak var liverLb: UILabel!
    @IBOutlet weak var intestineLb: UILabel!
    @IBOutlet weak var corneaLb: UILabel!
    @IBOutlet weak var pancreasLb: UILabel!
    @IBOutlet weak var boneMarrowLb: UILabel!
    
    
    @IBOutlet weak var popupStack: UIStackView!
    
    let db = Firestore.firestore()
    var bloodRow = [bloodTypeAndValue]()
    var organsRow = [organsAndValue]()
    
    //ContextMenu view <by deema>
    @IBOutlet weak var menuView: UIView!
    
    
    
    
    override func viewDidLoad() {
        
             popupStack.superview?.bringSubviewToFront(popupStack)

                popupView.layer.cornerRadius = 35
                cancelBtn.layer.cornerRadius = 20
                confirmBtn.layer.cornerRadius = 20
        
        
        
       
        
        
        
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            
            getBloodShortage(userID:user!.uid)
            
            getOrganShortageByMap(userID:user!.uid)
            
            
        } else {
            // No user is signed in.
            print("No user is signed in")
            // ...
        }
        
        
        
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        // font style for blood
        aPositive.font = UIFontMetrics.default.scaledFont(for: customFont)
        aPositive.adjustsFontForContentSizeCategory = true
        
        oPositive.font = UIFontMetrics.default.scaledFont(for: customFont)
        oPositive.adjustsFontForContentSizeCategory = true
        
        bPositive.font = UIFontMetrics.default.scaledFont(for: customFont)
        bPositive.adjustsFontForContentSizeCategory = true
        
        abPositive.font = UIFontMetrics.default.scaledFont(for: customFont)
        abPositive.adjustsFontForContentSizeCategory = true
        
        aNegative.font = UIFontMetrics.default.scaledFont(for: customFont)
        aNegative.adjustsFontForContentSizeCategory = true
        
        bNegative.font = UIFontMetrics.default.scaledFont(for: customFont)
        bNegative.adjustsFontForContentSizeCategory = true
        
        oNegative.font = UIFontMetrics.default.scaledFont(for: customFont)
        oNegative.adjustsFontForContentSizeCategory = true
        
        abNegative.font = UIFontMetrics.default.scaledFont(for: customFont)
        abNegative.adjustsFontForContentSizeCategory = true
        
        bloodShortageNeed.font = UIFontMetrics.default.scaledFont(for: customFont)
        bloodShortageNeed.adjustsFontForContentSizeCategory = true
        bloodShortageNeed.font = bloodShortageNeed.font.withSize(24)
        
        
        // font style for organs
        heart.font = UIFontMetrics.default.scaledFont(for: customFont)
        heart.adjustsFontForContentSizeCategory = true
        
        heartLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        heartLb.adjustsFontForContentSizeCategory = true
        
        lung.font = UIFontMetrics.default.scaledFont(for: customFont)
        lung.adjustsFontForContentSizeCategory = true
        
        lungLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        lungLb.adjustsFontForContentSizeCategory = true
        
        liver.font = UIFontMetrics.default.scaledFont(for: customFont)
        liver.adjustsFontForContentSizeCategory = true
        
        liverLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        liverLb.adjustsFontForContentSizeCategory = true
        
        kidney.font = UIFontMetrics.default.scaledFont(for: customFont)
        kidney.adjustsFontForContentSizeCategory = true
        
        kidneyLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        kidneyLb.adjustsFontForContentSizeCategory = true
        
        pancreas.font = UIFontMetrics.default.scaledFont(for: customFont)
        pancreas.adjustsFontForContentSizeCategory = true
        
        pancreasLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        pancreasLb.adjustsFontForContentSizeCategory = true
        
        cornea.font = UIFontMetrics.default.scaledFont(for: customFont)
        cornea.adjustsFontForContentSizeCategory = true
        
        corneaLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        corneaLb.adjustsFontForContentSizeCategory = true
        
        intestine.font = UIFontMetrics.default.scaledFont(for: customFont)
        intestine.adjustsFontForContentSizeCategory = true
        
        intestineLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        intestineLb.adjustsFontForContentSizeCategory = true
        
        boneMarrow.font = UIFontMetrics.default.scaledFont(for: customFont)
        boneMarrow.adjustsFontForContentSizeCategory = true
        
        boneMarrowLb.font = UIFontMetrics.default.scaledFont(for: customFont)
        boneMarrowLb.adjustsFontForContentSizeCategory = true
        
        organShortageNeed.font = UIFontMetrics.default.scaledFont(for: customFont)
        organShortageNeed.adjustsFontForContentSizeCategory = true
        organShortageNeed.font = organShortageNeed.font.withSize(24)
        
        // font style for shortage need
        //        shortageNeed.font = UIFontMetrics.default.scaledFont(for: customFont)
        //        shortageNeed.adjustsFontForContentSizeCategory = true
        //        shortageNeed.font = shortageNeed.font.withSize(32)
        
        bloodUpdateBtn.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 24)
        //bloodUpdateBtn.contentHorizontalAlignment = .center
        //bloodUpdateBtn.contentVerticalAlignment = .center
        
        
        organUpdateBtn.titleLabel?.font =  UIFont(name: "Tajawal-Regular", size: 24)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.hideHairline()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark"), NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark")!, NSAttributedString.Key.font: customFont]
    }
    
    func getOrganShortageByMap(userID:String){
        
        db.collection(Constants.FStore.hospitalCollection).document(userID).addSnapshotListener{(QuerySnapshot,error) in
            if let e = error{
                print("there was an issue fetching organ shortage from firestore. \(e)")
            }else {
                if let snapshotDocuments = QuerySnapshot{
                    
                    let data = snapshotDocuments.data()
                    
                    if let organShortageMapField = data?[Constants.FStore.oShField] as? [String : Int]{
                        
                        print("lung from map \(organShortageMapField[Constants.FStore.lung]!)")
                        
                        let heartData = (organShortageMapField[Constants.FStore.heart]!)
                        let lungData = (organShortageMapField[Constants.FStore.lung]!)
                        let kidneyData = (organShortageMapField[Constants.FStore.kidney]!)
                        let liverData = (organShortageMapField[Constants.FStore.liver]!)
                        let corneaData = (organShortageMapField[Constants.FStore.cornea]!)
                        let pancreasData = (organShortageMapField[Constants.FStore.pancreas]!)
                        let boneMarrowData = (organShortageMapField[Constants.FStore.boneMarrow]!)
                        let intestineData = (organShortageMapField[Constants.FStore.intestine]!)
                        
                        // for updating organ shortage
                        self.organsRow = [
                            organsAndValue(organ: "قلب", value: heartData),
                            organsAndValue(organ: "رئة", value: lungData),
                            organsAndValue(organ: "كلية", value: kidneyData),
                            organsAndValue(organ: "كبد", value: liverData),
                            organsAndValue(organ: "امعاء", value: intestineData),
                            organsAndValue(organ: "قرنية", value: corneaData),
                            organsAndValue(organ: "بنكرياس", value: pancreasData),
                            organsAndValue(organ: "نخاع العظم", value: boneMarrowData),
                            
                        ]
                        
                        
                        
                        
                        let organShort = organShortage(heart: heartData, lung: lungData, kidney: kidneyData, liver: liverData, pancreas: pancreasData, intestine: intestineData, cornea: corneaData, boneMarrow: boneMarrowData)
                        
                        // convert to arabic digits
                        let heartArabic =  String(organShort.heart).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let lungArabic =  String(organShort.lung).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let liverArabic =  String(organShort.liver).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let kidneyArabic =  String(organShort.kidney).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let corneaArabic =  String(organShort.cornea).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let pancreasArabic =  String(organShort.pancreas).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let boneMarroArabic =  String(organShort.boneMarrow).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let intestineArabic =  String(organShort.intestine).convertedDigitsToLocale(Locale(identifier: "AR"))
                        
                        
                        
                        
                        self.heart.text = heartArabic
                        self.lung.text = lungArabic
                        self.liver.text = liverArabic
                        self.kidney.text = kidneyArabic
                        self.intestine.text = intestineArabic
                        self.cornea.text = corneaArabic
                        self.pancreas.text = pancreasArabic
                        self.boneMarrow.text = boneMarroArabic
                        
                        
                    }
                }
            }
            
            
        }
        
    }
    
    func getBloodShortage(userID:String){
        //current user
        db.collection(Constants.FStore.hospitalCollection).document(userID).addSnapshotListener{(QuerySnapshot,error) in // addSnapshotListener instead of getDocuments
            if let e = error{
                print("there was an issue fetching blood shortage from firestore. \(e)")
            }else {
                if let snapshotDocuments = QuerySnapshot{
                    
                    let data = snapshotDocuments.data()
                    
                    // var bloodShortageMapField = [String : Int]()
                    if let bloodShortageMapField = data?[Constants.FStore.bShField] as? [String : Int]{
                        
                        
                        
                        let aPos = (bloodShortageMapField[Constants.FStore.aPos]!)
                        let bPos = (bloodShortageMapField[Constants.FStore.bPos]!)
                        let oPos = (bloodShortageMapField[Constants.FStore.oPos]!)
                        let abPos = (bloodShortageMapField[Constants.FStore.abPos]!)
                        
                        let aNeg = (bloodShortageMapField[Constants.FStore.aNeg]!)
                        let bNeg = (bloodShortageMapField[Constants.FStore.bNeg]!)
                        let oNeg = (bloodShortageMapField[Constants.FStore.oNeg]!)
                        let abNeg = (bloodShortageMapField[Constants.FStore.abNeg]!)
                        
                        // for updating blood shortage
                        self.bloodRow = [
                            bloodTypeAndValue(bloodType: "A+",value: aPos),
                            bloodTypeAndValue(bloodType: "A-",value: aNeg),
                            
                            bloodTypeAndValue(bloodType: "B+",value: bPos),
                            bloodTypeAndValue(bloodType: "B-",value: bNeg),
                            
                            bloodTypeAndValue(bloodType: "O+",value: oPos),
                            bloodTypeAndValue(bloodType: "O-",value: oNeg),
                            
                            bloodTypeAndValue(bloodType: "AB+",value: abPos),
                            bloodTypeAndValue(bloodType: "AB-",value: abNeg)
                            
                        ]
                        
                        
                        let bloodShort = bloodShortage(aPos: aPos, aNeg: aNeg, oPos: oPos, oNeg: oNeg, bPos: bPos, bNeg: bNeg, abPos: abPos, abNeg: abNeg)
                        
                        
                        
                        let aPosArabic =  String(bloodShort.aPos).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let bPosArabic =  String(bloodShort.bPos).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let oPosArabic =  String(bloodShort.oPos).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let abPosArabic =  String(bloodShort.abPos).convertedDigitsToLocale(Locale(identifier: "AR"))
                        
                        let aNegArabic =  String(bloodShort.aNeg).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let bNegArabic =  String(bloodShort.bNeg).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let oNegArabic =  String(bloodShort.oNeg).convertedDigitsToLocale(Locale(identifier: "AR"))
                        let abNegArabic =  String(bloodShort.abNeg).convertedDigitsToLocale(Locale(identifier: "AR"))
                        
                        
                        
                        
                        self.aPositive.text = "\(aPosArabic) وحدة"
                        self.oPositive.text = "\(oPosArabic) وحدة"
                        self.bPositive.text = "\(bPosArabic) وحدة"
                        self.abPositive.text = "\(abPosArabic) وحدة"
                        
                        self.aNegative.text = "\(aNegArabic) وحدة"
                        self.oNegative.text = "\(oNegArabic) وحدة"
                        self.bNegative.text = "\(bNegArabic) وحدة"
                        self.abNegative.text = "\(abNegArabic) وحدة"
                        
                    }
                }
            }
            
            
        }
        
    }
//    @IBAction func onPressedLogout(_ sender: Any) {
//
//                popupTitle.text = "تأكيد تسجيل الخروج"
//                popupMsg.text = "هل أنت متأكد من أنك تريد تسجيل الخروج؟"
//
//               popupView.isHidden = false
//               blurredView.isHidden = false
//
//    }
    
    
    @IBAction func onPressedCancel(_ sender: Any) {
   
        
                popupView.isHidden = true
               blurredView.isHidden = true
        
    }
    
    
    
    @IBAction func onPressedConfirm(_ sender: Any) {
   
        
        
        do
        {
            try Auth.auth().signOut()
            transitionToLogIn()
            
            

            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            
       
        }
        
        
    }
    
    
    func transitionToLogIn(){
        Constants.Globals.isLoggingOut = true

   
        let signInViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.updateBloodShSegue {
            
            // Create a new variable to store the instance of updateBloodShortageVC
            let destinationVC = segue.destination as! updateBloodShortageVC
            destinationVC.delegate=self
            destinationVC.bloodTypeArray = bloodRow
            destinationVC.oldBloodTypeArray = bloodRow
            
        }
        
        
        if segue.identifier == Constants.Segue.updateOrgansShSegue { // make sure it matches the segue id
            
            // Create a new variable to store the instance of updateBloodShortageVC
            let destinationVC = segue.destination as! updateOrganShortageVC
            destinationVC.delegate=self
            destinationVC.organsArray = organsRow
            destinationVC.oldOrgansArray = organsRow
            //updateOrganShortageVC
        }
        
    }
    
    @IBAction func viewMenu(_ sender: Any) {
        let profile = ContextMenuItemWithImage(title: "ملف المستشفى", image: UIImage(systemName: "star.fill")!)
        let donorsList = ContextMenuItemWithImage(title: "قائمة المتبرعين  بالاعضاء", image: UIImage(systemName: "star.fill")!)
        let logout = ContextMenuItemWithImage(title: "تسجيل الخروج", image: UIImage(systemName: "star.fill")!)
        
        CM.items = [profile,donorsList,logout]
        CM.showMenu(viewTargeted: menuView, delegate: self, animated: true)
    }
    
    
    
} // end of class






struct bloodTypeAndValue {
    
    let bloodType : String
    var value : Int
    
    init(bloodType : String, value : Int) {
        self.bloodType = bloodType
        self.value = value
    }
    
}

struct organsAndValue {
    let organ : String
    var value : Int
    
}



// extension to convert digits from any language to any language
extension String {
    private static let formatter = NumberFormatter()
    
    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
    
    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }
        
        Self.formatter.locale = locale
        
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }
        
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}




extension HospitalHomeMainViewController : BloodShortageDelegate,  OrganShortageDelegate{
    
    
    
    func onOrganUpdateCompletion(toastType: String) {
        //updateOrganShortageVC().delegate=self
        
        if toastType == "pass" {
            components().showToast(message: "تم تحديث احتياج الأعضاء بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
        }
        
        else {
            components().showToast(message: "حدثت مشكلة اثناء تحديث احتياج الأعضاء، لم يتم تحديث احتياج  الأعضاء", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
        }
    }
    
    
    
    func onBloodUpdateCompletion(toastType : String){
        updateBloodShortageVC().delegate=self
        
        if toastType == "pass" {
            components().showToast(message: "تم تحديث احتياج الدم بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!,viewC: self)
        }
        
        else {
            components().showToast(message: "حدثت مشكلة اثناء تحديث احتياج الدم، لم يتم تحديث احتياج  الدم", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!,viewC: self)
        }
        
        
    }
    
    
    
    
    
    
    //end f extension
}

extension HospitalHomeMainViewController: ContextMenuDelegate {

    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        
        if(item.title == "ملف المستشفى"){
            performSegue(withIdentifier: "hospitalProfile", sender: self)
        }
        if(item.title == "قائمة المتبرعين  بالاعضاء"){
            performSegue(withIdentifier: "afterDeathDonors", sender: self)
            print("here")
        }
        if(item.title == "تسجيل الخروج"){
            popupTitle.text = "تأكيد تسجيل الخروج"
            popupMsg.text = "هل أنت متأكد من أنك تريد تسجيل الخروج؟"
    
           popupView.isHidden = false
           blurredView.isHidden = false
        }
        return true
    }

    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {

    }

    func contextMenuDidAppear(_ contextMenu: ContextMenu) {

    }

    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {

    }


}
