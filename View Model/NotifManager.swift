//
//  NotificationManager.swift
//  MiniChallenge3
//
//  Created by Lucinda Artahni on 22/08/24.
//

import Foundation
import UserNotifications
import CoreLocation

class NotifManager{
    static let instance = NotifManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success")
            }
        }
    }

    
    func scheduleNotification(for region: CLCircularRegion) {
        let content = UNMutableNotificationContent()
        content.title = "This is notification"
        content.body = "This is body"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
        
        print("Notification added")
    }
    
    
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
