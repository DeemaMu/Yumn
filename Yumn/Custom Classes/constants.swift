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
        static let signInViewController = "SignIn1"
        static let hospitalHomeViewController = "navToHospitalHome"
        
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
        static var isLoggingOut = false
    }
    
    struct UserInfo {
        static var userID = ""
    }
    
    static let cellNibName = "bloodTypeCell"
    static let cellNibNameOrgans = "organCell"
    static let cellIdentifier = "reusableCell"
    static let cellIDOrgans = "reusableCellOrgan"
    
    struct Segue {
        static let updateBloodShSegue = "updateBlood"
        static let updateOrgansShSegue = "updateOrgans"
    }
    
    struct FStore {
        static let hospitalCollection = "hospitalsInformation"
        static let usersCollection = "users"
        static let volunteerCollection = "volunteer"
        
        static let cityField = "city"
        static let bShField = "bloodShortage"
        static let oShField = "organShortage"
        static let totalBloodShDoc = "totalBloodShortage"
        static let totalOrganShDoc = "totalOrganShortage"
        
        static let aPos = "A_pos"
        static let bPos = "B_pos"
        static let oPos = "O_pos"
        static let abPos = "AB_pos"
        static let aNeg = "A_neg"
        static let bNeg = "B_neg"
        static let oNeg = "O_neg"
        static let abNeg = "AB_neg"
        
        
        static let lung = "lung"
        static let heart = "heart"
        static let liver = "liver"
        static let pancreas = "pancreas"
        static let kidney = "kidney"
        static let cornea = "cornea"
        static let boneMarrow = "boneMarrow"
        static let intestine = "intestine"
    }
    
    struct Colors {
        static let green = UIColor(red: 0.45, green: 0.58, blue: 0.21, alpha: 1.00)
        static let yellow = UIColor(red: 0.93, green: 0.78, blue: 0.26, alpha: 1.00)
        static let orange = UIColor(red: 0.93, green: 0.44, blue: 0.18, alpha: 1.00)
        static let pink = UIColor(red: 0.70, green: 0.21, blue: 0.33, alpha: 1.00)
        
    }
    
    struct VolunteeringOpp {
        static var title = ""
        static var date = ""
        static var endDate = ""
        static var start_date: Date = Date()
        static var end_date: Date = Date()
        static var workingHours = ""
        static var location  = ""
        static var gender = ""
        static var description = ""
        
    }
    
    struct selected {
        static var selectedDate: Date = Date()
    }
    
}
