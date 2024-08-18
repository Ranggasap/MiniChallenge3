//
//  LocationManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import Combine
import CoreLocation
import MapKit
import AVFoundation

extension iOSLocationView {
    class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
        @Published var isLocationTrackingEnabled = false
        @Published var location: CLLocation?
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        @Published var pins: [PinLocation] = []
        @Published var routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)] = []
        @Published var sliderValue: Double = 0
        @Published var showSlider = false
        
        let mgr: CLLocationManager
        var audioPlayer: AVPlayer?
        
        override init() {
            mgr = CLLocationManager()
            mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            mgr.distanceFilter = kCLDistanceFilterNone
            mgr.requestAlwaysAuthorization()
            mgr.allowsBackgroundLocationUpdates = true
            
            super.init()
            mgr.delegate = self
        }
        
        func enable() {
            mgr.startUpdatingLocation()
        }
        
        func disable() {
            mgr.stopUpdatingLocation()
            updateRegionForEntireRoute()
            sliderValue = maxSliderValue
            showSlider = true
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let currentLocation = locations.last {
                location = currentLocation
                appendPin(location: currentLocation)
                updateRegion(location: currentLocation)
            }
        }
        
        func appendPin(location: CLLocation) {
            let timestamp = Date()  // Capture the timestamp immediately
            pins.append(PinLocation(coordinate: location.coordinate, timestamp: timestamp))
            routeCoordinates.append((location.coordinate, timestamp))
        }
        
        func updateRegion(location: CLLocation) {
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
            )
        }
        
        func updateRegionForEntireRoute() {
            guard !routeCoordinates.isEmpty else { return }
            let coordinates = routeCoordinates.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            let mapRect = polyline.boundingMapRect
            region = MKCoordinateRegion(mapRect)
        }
        
        func startStopLocationTracking() {
            isLocationTrackingEnabled.toggle()
            if isLocationTrackingEnabled {
                enable()
                showSlider = false
            } else {
                disable()
            }
        }
        // test
        var maxSliderValue: Double {
            guard let firstTimestamp = routeCoordinates.first?.timestamp,
                  let lastTimestamp = routeCoordinates.last?.timestamp else {
                return 0
            }
            return lastTimestamp.timeIntervalSince(firstTimestamp)
        }
        
        
        func routeUpToSliderValue() -> [CLLocationCoordinate2D] {
            guard let firstTimestamp = routeCoordinates.first?.timestamp else { return [] }
            
            let targetTimestamp = firstTimestamp.addingTimeInterval(sliderValue)
            return routeCoordinates.filter { $0.timestamp <= targetTimestamp }.map { $0.coordinate }
        }
        
        
        func startEndPinLocations() -> (start: PinLocation?, end: PinLocation?) {
            guard let firstTimestamp = routeCoordinates.first?.timestamp else { return (nil, nil) }
            
            let targetTimestamp = firstTimestamp.addingTimeInterval(sliderValue)
            let startPin = pins.first
            let endPin = pins.last { $0.timestamp <= targetTimestamp }
            
            return (startPin, endPin)
        }
        
        
        func timestampForSliderValue() -> TimeInterval? {
            guard let firstTimestamp = routeCoordinates.first?.timestamp else { return nil }
            
            return sliderValue
        }
        
        func outputSliderValueLocationData() {
            // Get the exact coordinate at the current slider value
            guard let firstTimestamp = routeCoordinates.first?.timestamp else {
                print("No location data available.")
                return
            }
            
            // Calculate the target timestamp
            let targetTimestamp = firstTimestamp.addingTimeInterval(sliderValue)
            
            // Find the closest coordinate to the target timestamp
            if let closestLocation = routeCoordinates.min(by: { abs($0.timestamp.timeIntervalSince(targetTimestamp)) < abs($1.timestamp.timeIntervalSince(targetTimestamp)) }) {
                let latitude = closestLocation.coordinate.latitude
                let longitude = closestLocation.coordinate.longitude
                print("Current location at slider value (\(sliderValue) seconds):")
                print("Lat: \(latitude), Lon: \(longitude)")
            } else {
                print("No location data available for the current slider value.")
            }
        }
        
        
        func playAudio(fromTimestamp timestamp: TimeInterval) {
            guard let url = Bundle.main.url(forResource: "testSong", withExtension: "mp3") else {
                print("Audio file not found")
                return
            }
            audioPlayer = AVPlayer(url: url)
            let seekTime = CMTime(seconds: timestamp, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            audioPlayer?.seek(to: seekTime)
            audioPlayer?.play()
        }
        
        func pauseAudio(){
            audioPlayer?.pause()
        }
    }
}
