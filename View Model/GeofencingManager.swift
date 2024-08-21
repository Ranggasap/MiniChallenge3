//
//  GeofencingManager.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 20/08/24.
//

//TODO: rapiin corelocation, samain ama yang code bv
import Foundation
import CoreLocation
import CloudKit

class GeofencingManager:  NSObject, ObservableObject, CLLocationManagerDelegate{
    private var locationManager: CLLocationManager
    private var monitoredRegions: [CLCircularRegion] = []
    @Published var currentLocation: CLLocation?
   
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self

        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
           case .notDetermined:
            manager.requestLocation()
           case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
           case .restricted, .denied:
               print("Location services are denied or restricted.")
           @unknown default:
               fatalError("Unknown authorization status.")
           }
       }
    

    
    func startMonitoringForReports(_ reports: [Report]) {
        for region in monitoredRegions {
                  locationManager.stopMonitoring(for: region)
              }
              monitoredRegions.removeAll()
        
        for report in reports {
            let location = report.location
            let region = CLCircularRegion(
                center: location.coordinate,
                radius: 10,
                identifier: report.reportKronologi /*report.reportID?.recordName ?? UUID().uuidString*/
            )
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            monitoredRegions.append(region)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for currentLocation in locations {
//            print("\(index): \(currentLocation)")
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let latestLocation = locations.last else { return }
            currentLocation = latestLocation
        }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Entered geofence at location: \(circularRegion.center)")
            print("\(region.identifier)")
            // Handle geofence entry
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Exited geofence at location: \(circularRegion.center)")
            // Handle geofence exit
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error.localizedDescription)")
        if let clError = error as? CLError {
                switch clError.code {
                case .denied:
                    print("Location services denied.")
                case .network:
                    print("Network error.")
                case .locationUnknown:
                    print("Location unknown error.")
                case .headingFailure:
                    print("Heading failure error.")
                case .regionMonitoringDenied:
                    print("Region monitoring denied.")
                case .regionMonitoringFailure:
                    print("Region monitoring failure.")
                case .rangingFailure:
                    print("Ranging failure error.")
                default:
                    print("Other error: \(clError.code.rawValue)")
                }
            }
    }
    
    
    
}

