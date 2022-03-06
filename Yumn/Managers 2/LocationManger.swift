import Foundation
import MapKit
import CoreLocation


class LocationManager: NSObject, ObservableObject {
    
    let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func getUserLocation() -> CLLocationCoordinate2D? {
        self.locationManager.delegate = self
        locationManager.requestLocation()
        location = locationManager.location
        return location?.coordinate
    }
        
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
            print("error:: \(error)")
        }
    
}
