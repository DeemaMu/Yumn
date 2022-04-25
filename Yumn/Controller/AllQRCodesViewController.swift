//
//  AllQRCodesViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 18/04/2022.
//

import UIKit
import Firebase
import Foundation


class AllQRCodesViewController: UIViewController, CustomSegmentedControlDelegate {
    
    //var sortedValidQRCodes:[QRCode]?
    
    var qrController = QRController()


    @IBOutlet weak var validQRCodesTableView: UITableView!
    
    
    @IBOutlet weak var whiteView: UIView!
    
    var codeSegmented:CustomSegmentedControl2Btns? = nil

    @IBOutlet weak var segmentsView: UIView!
    
    
    override func viewDidLoad() {
        
        Constants.Globals.sortedValidQRCodes = getValidQRCodes()
        
        validQRCodesTableView.isHidden = true
        super.viewDidLoad()
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        whiteView.layer.cornerRadius = 35
        
        
        
        codeSegmented = CustomSegmentedControl2Btns(frame: CGRect(x: 0, y: 0, width: segmentsView.frame.width, height: 50), buttonTitle: ["الرموز الصالحة","الرموز المستخدمة"])
        codeSegmented!.backgroundColor = .clear
        //        codeSegmented.delegate?.change(to: 2)
        segmentsView.addSubview(codeSegmented!)
        codeSegmented?.delegate = self
        
        Constants.Globals.sortedValidQRCodes = getValidQRCodes()
        
        print("sorted up ")
        print (Constants.Globals.sortedValidQRCodes)
        
        
        validQRCodesTableView.dataSource = self
     
        
        validQRCodesTableView.register(UINib(nibName: "QRCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "QRCell")

        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        

    }
    
    
    func change(to index: Int) {
            print("segmentedControl index changed to \(index)")
            if(index==0){
                
                validQRCodesTableView.isHidden = false
                
                
                
            }
             else {
                 
                 
             }
        
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}

struct QRController {
}

extension AllQRCodesViewController{
    

    
    func getValidQRCodes() -> [QRCode]{
        
        var validQRCodes:[QRCode] = []
       
        let db = Firestore.firestore()

        
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
                Constants.Globals.sortedValidQRCodes = validQRCodes //validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                        //return QR0.amount < QR1.amount
                    //})
                
                print("sorted down")
                print (Constants.Globals.sortedValidQRCodes)

                    
                    DispatchQueue.main.async {
                        self.validQRCodesTableView.reloadData()
                    }
                

                    
                    
                    
                    
                    
                }
            }
            
            let validQRCodes2 = validQRCodes.sorted(by: { (QR0: QRCode, QR1: QRCode) -> Bool in
                return QR0.amount < QR1.amount
            })
            
        print ("heeeeeeeeere2")
        print (validQRCodes2)
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
    
 
extension AllQRCodesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Globals.sortedValidQRCodes!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 300.3
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) as! QRCodeTableViewCell
        
        
        
        cell.amount.text! = convertEngToArabic(num:  Constants.Globals.sortedValidQRCodes![indexPath.row].amount)
        
        cell.createdAt.text! =
        Constants.Globals.sortedValidQRCodes![indexPath.row].dateCreated
        
       
        
        cell.id = Constants.Globals.sortedValidQRCodes![indexPath.row].id
        
        print ("celllllllllll")
        print (cell)
        
        
        return cell
        

    
}
    
    
    
  

}
