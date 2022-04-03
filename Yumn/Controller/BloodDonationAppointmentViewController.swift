//
//  BloodDonationAppointmentViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 03/04/2022.
//

import UIKit
import SwiftUI


class BloodDonationAppointmentViewController: UIViewController {

    @IBOutlet weak var roundView: UIView!
    
    override func viewDidLoad() {
        
        //roundView.layer.cornerRadius = 35
        
        super.viewDidLoad()
        let vc = UIHostingController (rootView: BloodDonationAppointment())
        present(vc, animated: false)

        // Do any additional setup after loading the view.
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

struct BloodDonationAppointment: View {
    var body: some View {
        ScrollView {
            HStack{
                ForEach(0..<30) { index in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(width: 200, height: 150)
                        .shadow(radius: 10)
                        .padding()
                
            }
        }
        
        }}
    }

struct BloodDonationAppointment_Previews: PreviewProvider {
    static var previews: some View {
        BloodAppointmentView()
    }
}


