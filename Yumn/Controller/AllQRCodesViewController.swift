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
    
    var sortedValidQRCodes:[QRCode]?
    
    var qrController = QRController()


    @IBOutlet weak var validQRCodesTableView: UITableView!
    
    
    
    @IBOutlet weak var whiteView: UIView!
    
    var codeSegmented:CustomSegmentedControl2Btns? = nil

    @IBOutlet weak var segmentsView: UIView!
    
    
    override func viewDidLoad() {
        
        
        
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
        
        self.sortedValidQRCodes = getValidQRCodes()
        
        print("sorted up ")
        print (self.sortedValidQRCodes)
        
        self.sortedValidQRCodes = getValidQRCodes()

        
        print("sorted up 2")
        print (self.sortedValidQRCodes)
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
                 
                 
                 validQRCodesTableView.isHidden = true
                 
                 
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

    
 
extension AllQRCodesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedValidQRCodes!.count
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 300.3
    }*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0//Choose your custom row height
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) as! QRCodeTableViewCell
        
        
        
        cell.amount.text! = convertEngToArabic(num:  sortedValidQRCodes![indexPath.row].amount)
        
        print (cell.amount.text!)
        
        cell.createdAt.text! = "تم إنشاؤه في: " +
        sortedValidQRCodes![indexPath.row].dateCreated
        
       
        
        cell.id = sortedValidQRCodes![indexPath.row].id
        
       // print ("celllllllllll")
       // print (cell)
        
        
        return cell
        

    
}
    
    
    
  

}
