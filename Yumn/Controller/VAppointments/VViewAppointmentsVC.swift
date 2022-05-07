//
//  AfterDeathODFirstController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import ContextMenuSwift

class VViewAppointmentsVC: UIViewController {
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var innerPopup: UIView!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
//    @IBOutlet weak var popupTitle: UILabel!
//
//    @IBOutlet weak var popupMsg: UILabel!
//
//    @IBOutlet weak var okBtn: UIButton!
//
//    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var selectionHolder: UIView!
    
    @State var organAppointmentsList = [retrievedAppointment]()
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
            
        popupView.superview?.bringSubviewToFront(popupView)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //        contBtn.layer.cornerRadius = 25
//        okBtn.layer.cornerRadius = 15
//        saveBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
    }
    @IBAction func viewMenu(_ sender: Any) {
        let profile = ContextMenuItemWithImage(title: "الصفحة الشخصية", image: UIImage.init(named: "pofileHospital")!)
        let logout = ContextMenuItemWithImage(title: "تسجيل الخروج", image: UIImage.init(named: "signout")!)
        
        CM.items = [profile,logout]
        CM.showMenu(viewTargeted: menuView, delegate: self, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        let configuration = Configuration()
        let controller = UIHostingController(rootView: VAppointmentsView(config: configuration))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        self.addChild(controller)
        controller.view.frame = self.selectionHolder.bounds
        self.selectionHolder.addSubview(controller.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 23) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 23) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
    }
    
    func showConfirmationMessage(selected: [String:Bool], donor: Donor){
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
    }
    
//
    func cancel(apt: retrievedAppointment) {
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        let configuration = Configuration()
        let controller = UIHostingController(rootView: deleteAppointment(config: configuration,appointment: apt, controllerType: 1))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerPopup.bounds
        innerPopup.addSubview(controller.view)
    }
    
    
    func cancelDelete() {
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        innerPopup.removeSubviews()
    }
    
    func confirmDelete() {
        blackBlurredView.superview?.sendSubviewToBack(blackBlurredView)
        popupView.superview?.sendSubviewToBack(popupView)
        popupView.isHidden = true
        blackBlurredView.isHidden = true
        components().showToast(message: "تم حذف الموعد بنجاح", font: .systemFont(ofSize: 20), image: UIImage(named: "yumn-1")!, viewC: self)
        innerPopup.removeSubviews()
    }
    
    func editAppointment(apt: retrievedAppointment) {
        blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
        popupView.superview?.bringSubviewToFront(popupView)
        popupView.isHidden = false
        blackBlurredView.isHidden = false
        let configuration = Configuration()
        let controller = UIHostingController(rootView: Yumn.editAppointment(config: configuration,appointment: apt, controllerType: 1))
        // injects here, because `configuration` is a reference !!
        configuration.hostingController = controller
        addChild(controller)
        controller.view.frame = innerPopup.bounds
        innerPopup.addSubview(controller.view)
    }
    
    func bookAppointment() {
        performSegue(withIdentifier: "goToBook", sender: nil)
    }
    
    func bookBloodAppointment() {
        performSegue(withIdentifier: "goToBookBlood", sender: nil)
    }

    func moveToOldApts(){
        performSegue(withIdentifier: "goToOldApts", sender: nil)
    }
    
    func moveToFutureApts(){
        performSegue(withIdentifier: "goToFuture", sender: nil)
    }
    
    
}


struct retrievedAppointment : Identifiable {
    var id = UUID().uuidString
    var duration: Int?
    var date: Date?
    var startTime: Date?
    
    var endTime: Date?
    var hName: String?
    var hospitalID: String?
    var hospitalLocation: String?
    
    var mainAppointmentID: String?
    var appointmentID: String?
    var type: String?
    
    var organ: String?
    
    var status: String?
    var title: String?
    var endDate: Date?
    var description: String?
    var timeString: String?    
}

extension String {
         public enum DateFormatType {
        
        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear
        
        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
        case isoYearMonth
        
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate
        
        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
        case isoDateTime
        
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec
        
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
        case isoDateTimeMilliSec
        
        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
        case dotNet
        
        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        case rss
        
        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        case altRSS
        
        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        case httpHeader
        
        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        case standard
        
        /// A custom date format string
        case custom(String)
        
        /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
        case localDateTimeSec
        
        /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
        case localDate
        
        /// The local formatted  time "hh:mm a" i.e. 07:20 am
        case localTimeWithNoon
        
        /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
        case localPhotoSave
        
        case birthDateFormatOne
        
        case birthDateFormatTwo
        
        ///
        case messageRTetriveFormat
        
        ///
        case emailTimePreview
        
        var stringFormat:String {
          switch self {
          //handle iso Time
          case .birthDateFormatOne: return "dd/MM/YYYY"
          case .birthDateFormatTwo: return "dd-MM-YYYY"
          case .isoYear: return "yyyy"
          case .isoYearMonth: return "yyyy-MM"
          case .isoDate: return "yyyy-MM-dd"
          case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
          case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
          case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
          case .dotNet: return "/Date(%d%f)/"
          case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
          case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
          case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
          case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
          case .custom(let customFormat): return customFormat
            
          //handle local Time
          case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
          case .localTimeWithNoon: return "hh:mm a"
          case .localDate: return "yyyy-MM-dd"
          case .localPhotoSave: return "yyyyMMddHHmmss"
          case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
          case .emailTimePreview: return "dd MMM yyyy, h:mm a"
          }
        }
 }
        
 func toDate(_ format: DateFormatType = .isoDate) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
  }
 }
