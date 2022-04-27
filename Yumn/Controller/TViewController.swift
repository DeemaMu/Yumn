//
//  TViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 27/04/2022.
//

import UIKit
import Firebase

class TViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    

    
    var tArray:[T]?
    
    var tController = TController()

    
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.isHidden = false
        tArray = getTs()
        
        table.dataSource = self
        table.register(UINib(nibName: "TCell", bundle: nil), forCellReuseIdentifier: "tcell")
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


extension TViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tArray!.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as! TCell
        
        cell.label.text = tArray![indexPath.row].label
        
        
        print (cell.label.text!)
        
        return cell

        
    }

    
    
}
