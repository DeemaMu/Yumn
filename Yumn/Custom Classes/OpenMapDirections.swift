import CoreLocation
import MapKit
import UIKit

class OpenMapDirections {
    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
    static func present(in viewController: UIViewController, sourceView: UIView , latitude : Double, longitude : Double ,popUp : UIView , popUpMsg : UILabel , blurredView : UIView) {
        let actionSheet = UIAlertController(title: "Open Location", message: "Choose an app to open direction", preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            // Pass the coordinate inside this URL
            let url = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude))&directionsmode=driving&zoom=14&views=traffic")!
          
            if (UIApplication.shared.canOpenURL(url)){
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
            
            else {
                //oldTableViewController().hideMapPopUp()
                popUp.isHidden = false
                blurredView.isHidden = false
                popUpMsg.text = "لفتح الموقع على Google maps يجب عليك تحميل التطبيق من متجر التطبيقات"
                print("goolge map is not installed")
            }
       
        
        }))
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            // Pass the coordinate that you want here
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = "Destination"
            // change it 
            let url = URL(string: "http://maps.apple.com/\(coordinate)")!
            if (UIApplication.shared.canOpenURL(url)){
                
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            else {
                popUp.isHidden = false
                blurredView.isHidden = false
                popUpMsg.text = "لفتح الموقع على Apple map يجب عليك تحميل التطبيق من متجر التطبيقات"
                print("apple map is not installed")
                
            }
        }))
        
        
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}


/*
 
 // func for button click
 // pass lat and long
 @objc func askToOpenMap() {
       OpenMapDirections.present(in: self, sourceView: locationButton)
   }
 
 
 */
