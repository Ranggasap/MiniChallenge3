//
//  TestingLocationNotif.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 21/08/24.
//

import SwiftUI
import CoreLocation

struct TestingLocationNotif: View {
    
    @StateObject private var locationManager = LocationNotificationManager()
    @State private var isMonitoringRegion = false
    
    var body: some View {
        VStack{
            if let location = locationManager.currentLocation {
                Text("Your location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    .padding()
            } else {
                Text("Location...")
                    .padding()
            }
            
            Button(action: startMonitoringRegion) {
                Text("Start Monitoring Region")
            }
            .padding()
        }
        .onAppear{
            NotificationManager2.shared.requestAuthorization()
        }
    }
    
    private func startMonitoringRegion() {
        
        let appleDeveloperAcademyCoordinate = CLLocationCoordinate2D(latitude: -6.302005, longitude: 106.652006)
        
        guard let location = locationManager.currentLocation else { return }
        let region = CLCircularRegion(
            center: appleDeveloperAcademyCoordinate, radius: 100, identifier: "AppleDeveloperAcademyBSD"
        )
        region.notifyOnExit = false
        region.notifyOnEntry = true
        
        locationManager.startMonitoring(for: region)
        NotificationManager2.shared.scheduleLocationNotifications(for: region)
        isMonitoringRegion = true
    }
}

#Preview {
    TestingLocationNotif()
}
