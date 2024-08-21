//
//  LocationNotificationManager.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 21/08/24.
//

import CoreLocation
import Combine

class LocationNotificationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("Location is currently unknown, but will keep trying.")
            case .denied:
                print("Access to location services was denied.")
            default:
                print("Failed to find user's location: \(error.localizedDescription)")
            }
        } else {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    }
    
    func startMonitoring(for region: CLRegion) {
        locationManager.startMonitoring(for: region)
    }
}
