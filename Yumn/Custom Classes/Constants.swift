//
//  Constants.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 14/02/2022.
//

import Foundation
import UIKit


struct Constants {
    
    
    struct Storyboard{
        
      static let volunteerHomeViewController = "navToVHome"
      static let contSignUpViewController = "contSignUp"
      static let signInViewController = "SignIn"
      static let hospitalHomeViewController = "HospitalHome"
      static let qrViewController = "QR"

    }
    
    struct Globals {
         static var firstName = ""
         static var lastName = ""
         static var id = ""
         static var email = ""
         static var phone  = ""
         static var birthdate = ""
         static var password = ""
         static var city = ""
         static var gender = "f"
         static var weight = ""
         static var  bloodType = ""
         static var firstNameFromdb = ""
         static var currentQRID = "Zgtw52fTlum4bv7zpIlY"
         static var isLoggingIn = true
         static var sortedValidQRCodes:[QRCode]?
        static var hospitalId = "y5I2Wz29l1cz2zAt8dVc1wETEK13"
        static var appointmentDateArray:[DateCellInfo]?

                 
    }

    
   
}
