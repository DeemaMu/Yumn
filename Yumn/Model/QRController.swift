//
//  QRController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import Foundation
import CoreLocation
import Firebase


struct QRController {
}

extension AllQRCodesViewController{
    

    
    func getValidQRCodes() -> [QRCode]{
     
        var validQRCodes:[QRCode] = []

       
        let db = Firestore.firestore()

        // Add a condition to get only the user's QR codes
        db.collection("code").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting the documents:  \(err)")
            } else {
                for document in
                        querySnapshot!.documents{
                    let doc = document.data()
                    
                    let dateCreated: String = doc["dateCreated"] as! String
                    
                    let amount: Double =  doc["amount"] as! Double
                    
                    let id: String = doc["id"] as! String
                    
                    let status: String = doc["status"] as! String
                    
                    validQRCodes.append(QRCode(amount: amount, dateCreated: dateCreated, id: id, status: status ))
                    
                }
                self.sortedValidQRCodes = validQRCodes //validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                        //return QR0.amount < QR1.amount
                    //})
                
                print("sorted down")
                print (self.sortedValidQRCodes)

                 DispatchQueue.main.async {
                        self.validQRCodesTableView.reloadData()
                    }
                

                    
                    
                    
                    
                    
                }
            }
            
            let validQRCodes2 = validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                return QR0.amount < QR1.amount
            })
            
        print ("heeeeeeeeere2")
        print (validQRCodes)
            return validQRCodes
            
        

            
        }
    
    
    
    func  convertEngToArabic(num: Double)-> String{
        
        let points=String(num)
        var arabicString=""
        
        for ch in points{
            
            switch ch {
                
            case "0":
                arabicString+="٠"
            case "9":
                arabicString+="٩"
            case "8":
                arabicString+="٨"
            case "7":
                arabicString+="٧"
            case "6":
                arabicString+="٦"
            case "5":
                arabicString+="٥"
            case "4":
                arabicString+="٤"
            case "3":
                arabicString+="٣"
            case "2":
                arabicString+="٢"
            case "1":
                arabicString+="١"
            case ".":
                arabicString+="."
                
            default:
                arabicString="٠"
            }
        }
        return arabicString
    }


    
    

    
    
    
    
    
}
