//
//  NotificationManager.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 21/08/24.
//

import UserNotifications
import CoreLocation

struct NotificationManager {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations {
            print("\(String(describing: index)): \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
    }
    
    func checkForNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    completion(didAllow)
                }
            case .denied:
                completion(false)
            case .authorized:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    func dispatchNotification(for region: CLRegion) {
        let identifier = "auto-recording-notification"
        let title = "Auto Recording Activation"
        let body = "Click this notification to activate auto record"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotificationForAppleDeveloperAcademy() {
        let appleDeveloperAcademy = CLLocationCoordinate2D(latitude: -6.3021689081659025, longitude: 106.65255637667411)
        let regionRadius = 200
        
        let region = CLCircularRegion(center: appleDeveloperAcademy, radius: CLLocationDistance(regionRadius), identifier: "AppleDeveloperAcademyRegion")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        checkForNotificationPermission{ granted in
            if granted {
                self.dispatchNotification(for: region)
            } else {
                print("Notification permission not granted.")
            }
            
        }
    }
}
