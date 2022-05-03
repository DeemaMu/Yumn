//
//  QRController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseAuth


struct QRController {
}

extension AllQRCodesViewController{
    

    
    func getValidQRCodes(status: String) -> [QRCode]{
     
        var validQRCodes:[QRCode] = []

       
        let db = Firestore.firestore()

        // Add a condition to get only the user's QR codes
        db.collection("code").whereField("uid", isEqualTo: (Auth.auth().currentUser?.uid ?? "")).whereField("status", isEqualTo: status).getDocuments() { (querySnapshot, err) in
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
                self.sortedValidQRCodes = validQRCodes
                self.sortedValidQRCodes = validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                    return QR0.amount < QR1.amount})
                
                //validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                        //return QR0.amount < QR1.amount
                    //})
                
                print("sorted down")
                print (self.sortedValidQRCodes)

                 DispatchQueue.main.async {
                        self.validQRCodesTableView.reloadData()
                    }
                

                    
                    
                    
                    
                    
                }
            
            
            if (self.sortedValidQRCodes != nil){
            
            if (self.sortedValidQRCodes!.isEmpty){
                
                print ("empty valid qr")
                
                self.validQRCodesTableView.isHidden = true
                
               
                    
                    
          
                self.noCodesLabel.isHidden = false
                self.qrCodeImage.isHidden = false
                

                
                

            }
            
            else {
                self.noCodesLabel.isHidden = true
                self.qrCodeImage.isHidden = true
            }
            }}
            
            let validQRCodes2 = validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                return QR0.amount < QR1.amount
            })
            
        print ("heeeeeeeeere2")
        print (validQRCodes)
            return validQRCodes2
            
        

            
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
