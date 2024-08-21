//
//  NotificationManager2.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 21/08/24.
//

import UserNotifications
import CoreLocation

class NotificationManager2 {
    static let shared = NotificationManager2()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
            } else if let error = error {
                print("Permission denied: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleLocationNotifications(for region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = "You're in the area!"
        content.body = "You have entered the specified area."
        content.sound = UNNotificationSound.default
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
        
    }
}
