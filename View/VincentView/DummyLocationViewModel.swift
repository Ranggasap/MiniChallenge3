//
//  DummyLocationViewModel.swift
//  Mini3 Watch App
//
//  Created by Rangga Saputra on 21/08/24.
//

import UserNotifications
import CoreLocation

class DummyLocationViewModel {
    
    let notificationManager = NotificationManager()
    let locationManager = CLLocationManager()
    
    func triggerAppleDeveloperAcademyNotification() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        notificationManager.scheduleNotificationForAppleDeveloperAcademy()
    }
}
