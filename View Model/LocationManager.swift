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

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var isLocationTrackingEnabled = false
    @Published var storeLocation: [SavedLocation] = []
    
    // composition
    @Published var loadLocManager: LoadLocationManager
    
    let mgr: CLLocationManager
    
    override init() {
        self.loadLocManager = LoadLocationManager(region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ), pins: [], routeCoordinates: [], sliderValue: 0, showSlider: false, maxSliderValue: 0)
        
        mgr = CLLocationManager()
        mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mgr.distanceFilter = kCLDistanceFilterNone
        mgr.requestAlwaysAuthorization()
        mgr.allowsBackgroundLocationUpdates = true
        
        super.init()
        mgr.delegate = self
    }
    
    func enable() {
        loadLocManager.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        loadLocManager.pins = []
        loadLocManager.routeCoordinates = []
        loadLocManager.sliderValue = 0
        loadLocManager.showSlider = false
        mgr.startUpdatingLocation()
    }
    
    func disable() {
        mgr.stopUpdatingLocation()
        updateRegionForEntireRoute()
        countMaxSliderValue()
        loadLocManager.sliderValue = loadLocManager.maxSliderValue
        loadLocManager.showSlider = true
        storeLocation.append(SavedLocation(routeCoordinates: loadLocManager.routeCoordinates, pins: loadLocManager.pins, sliderValue: loadLocManager.sliderValue, showSlider: loadLocManager.showSlider, region: loadLocManager.region, maxSliderValue: loadLocManager.maxSliderValue))
    }
    
    func countMaxSliderValue() {
        guard let firstTimestamp = loadLocManager.routeCoordinates.first?.timestamp,
              let lastTimestamp = loadLocManager.routeCoordinates.last?.timestamp else {
            return
        }
        let value = lastTimestamp.timeIntervalSince(firstTimestamp)
        loadLocManager.maxSliderValue = value > 0 ? value : 0.1  // Ensure it is positive
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            appendPin(location: currentLocation)
            updateRegion(location: currentLocation)
        }
    }
    
    func appendPin(location: CLLocation) {
        let timestamp = Date()  // Capture the timestamp immediately
        loadLocManager.pins.append(PinLocation(coordinate: location.coordinate, timestamp: timestamp))
        loadLocManager.routeCoordinates.append((location.coordinate, timestamp))
    }
    
    func updateRegion(location: CLLocation) {
        loadLocManager.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        )
    }
    
    func startStopLocationTracking() {
        DispatchQueue.main.async {
            self.isLocationTrackingEnabled.toggle()
            if self.isLocationTrackingEnabled {
                self.enable()
                self.loadLocManager.showSlider = false
            } else {
                self.disable()
            }
        }
    }
    
    func updateRegionForEntireRoute() {
        loadLocManager.updateRegionForEntireRoute()
    }
    
    func routeUpToSliderValue() -> [CLLocationCoordinate2D] {
        return loadLocManager.routeUpToSliderValue()
    }
    
    
    func startEndPinLocations() -> (start: PinLocation?, end: PinLocation?) {
        return loadLocManager.startEndPinLocations()
    }
    
    
    func timestampForSliderValue() -> TimeInterval? {
        return loadLocManager.timestampForSliderValue()
    }
    
    func playAudio(fromTimestamp timestamp: TimeInterval) {
        loadLocManager.playAudio(fromTimestamp: timestamp)
    }
    
    func pauseAudio(){
        loadLocManager.pauseAudio()
    }
    
    //TODO: not needed I guess??
    func outputSliderValueLocationData() {
        // Get the exact coordinate at the current slider value
        guard let firstTimestamp = loadLocManager.routeCoordinates.first?.timestamp else {
            print("No location data available.")
            return
        }
        
        // Calculate the target timestamp
        let targetTimestamp = firstTimestamp.addingTimeInterval(loadLocManager.sliderValue)
        
        // Find the closest coordinate to the target timestamp
        if let closestLocation = loadLocManager.routeCoordinates.min(by: { abs($0.timestamp.timeIntervalSince(targetTimestamp)) < abs($1.timestamp.timeIntervalSince(targetTimestamp)) }) {
            let latitude = closestLocation.coordinate.latitude
            let longitude = closestLocation.coordinate.longitude
            print("Current location at slider value (\(loadLocManager.sliderValue) seconds):")
            print("Lat: \(latitude), Lon: \(longitude)")
        } else {
            print("No location data available for the current slider value.")
        }
    }
    
}
