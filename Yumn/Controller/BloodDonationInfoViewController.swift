//
//  BloodDonationInfoViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 15/03/2022.
//

import UIKit

class Section {
    let title: String
    let options: [String]
    var isOpened: Bool = false
    
    init(title: String,
        options: [String],
      isOpened: Bool = false
){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
    
}

class BloodDonationInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
        
    }()
    
    private var sections = [Section]()
    

    override func viewDidLoad() {
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        
        sections = [
            Section(title: "Section 1", options: [1].compactMap({return "Hi1 \($0)"})),
            Section(title: "Section 2", options: [1].compactMap({return "Hi2 \($0)"})),
        

        
        ]
        super.viewDidLoad()
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let section = sections[section]
        
        if section.isOpened {
            
            return section.options.count + 1
        }
        else {return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
              
        if indexPath.row == 0{
                  
            cell.textLabel?.text=sections[indexPath.section].title

        }
        
        else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                      
            cell.textLabel?.text=sections[indexPath.section].options[indexPath.row - 1]
        }
        
        return cell
        
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0{
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
        else {
            print ("tapped sub cells")
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
