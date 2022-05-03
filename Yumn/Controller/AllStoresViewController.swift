//
//  AllStoresViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/05/2022.
//

import UIKit
import FirebaseStorage


class AllStoresViewController: UIViewController {
    
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var backArrow: UIButton!
    @IBOutlet weak var allStoresTable: UITableView!
    
    @IBOutlet weak var noStoresLabel: UILabel!
    @IBOutlet weak var storesImage: UIImageView!

    
    
    var sortedStores:[Store]?
    
    var store = StoreController()
    
    
    override func viewDidLoad() {
        
        navigationItem.hidesBackButton = true
        
        roundView.layer.cornerRadius = 35
        super.viewDidLoad()
        
        sortedStores = getAllStores()
        
        

        allStoresTable.dataSource = self
     
        
        allStoresTable.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        
    }
    

    @IBAction func onPressedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
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


extension AllStoresViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedStores!.count
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 300.3
    }*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0//Choose your custom row height
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        
        let store = Storage.storage()
        let storeRef = store.reference()
        let logoRef = storeRef.child("Stores/" +  sortedStores![indexPath.row].name
                                     + ".png")
        
        
        logoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error \(error)")
              
              print ("nooooo image")
          } else {
              cell.storeImage.image = UIImage(data: data!)
          }
        }
                      
        
        cell.name.text! =  sortedStores![indexPath.row].name
        
        cell.instagram = sortedStores![indexPath.row].insta
        
        
        
        
         //change the image
        
       
        
        
       // print ("celllllllllll")
       // print (cell)
        
        
        return cell
        

    
}
    
}
