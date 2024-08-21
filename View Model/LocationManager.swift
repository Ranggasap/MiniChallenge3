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
    @Published var isDisabled = false
    @Published var storeLocation: [SaveLoc] = []
    
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
        isDisabled = false
        loadLocManager.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        loadLocManager.pins = []
        loadLocManager.routeCoordinates = []
        loadLocManager.sliderValue = 0
        storeLocation = []
        loadLocManager.showSlider = false
        mgr.startUpdatingLocation()
    }
    
    func disable() {
        mgr.stopUpdatingLocation()
        updateRegionForEntireRoute()
        countMaxSliderValue()
        loadLocManager.sliderValue = loadLocManager.maxSliderValue
        loadLocManager.showSlider = true
        isDisabled = true
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

extension iOSLocationView {
    func storeLocationToSwiftData() {
        // Create a new SavedLocation object with the current values from loadLocManager
        let savedLocation = SavedLocation(
            sliderValue: model.loadLocManager.sliderValue,
            showSlider: model.loadLocManager.showSlider,
            regionCenterLatitude: model.loadLocManager.region.center.latitude,
            regionCenterLongitude: model.loadLocManager.region.center.longitude,
            regionSpanLatitude: model.loadLocManager.region.span.latitudeDelta,
            regionSpanLongitude: model.loadLocManager.region.span.longitudeDelta,
            maxSliderValue: model.loadLocManager.maxSliderValue
        )
        
        // Insert the savedLocation into the SwiftData context
        savedLocation.insert(context)
        
        // Convert routeCoordinates to RouteCoordinate objects and append them to savedLocation
        for location in model.loadLocManager.routeCoordinates {
            let routeCoordinate = RouteCoordinate(
                routeLatitude: location.coordinate.latitude,
                routeLongitude: location.coordinate.longitude,
                routeTimestamp: location.timestamp.timeIntervalSince1970
            )
            savedLocation.routeCoordinates.append(routeCoordinate)
        }
        
        // Convert pins to PinnedLocation objects and append them to savedLocation
        for pin in model.loadLocManager.pins {
            let pinnedLocation = PinnedLocation(
                pinLatitude: pin.coordinate.latitude,
                pinLongitude: pin.coordinate.longitude,
                pinDate: pin.timestamp.timeIntervalSince1970
            )
            savedLocation.pinnedLocations.append(pinnedLocation)
        }
    }
    
    func convertToTempData() {
        for location in savedLocations {
            var pinLoc: [PinLocation] = []
            var routeCoor: [(coordinate: CLLocationCoordinate2D, timestamp: Date)] = []

            for pin in location.pinnedLocations {
                let coordinate = CLLocationCoordinate2D(latitude: pin.pinLatitude, longitude: pin.pinLongitude)
                let timestamp = Date(timeIntervalSince1970: pin.pinDate)
                pinLoc.append(PinLocation(coordinate: coordinate, timestamp: timestamp))
            }
            
            print("\npinLoc: \(pinLoc)\n")
            
            for route in location.routeCoordinates {
                let coordinate = CLLocationCoordinate2D(latitude: route.routeLatitude, longitude: route.routeLongitude)
                let timestamp = Date(timeIntervalSince1970: route.routeTimestamp)
                routeCoor.append((coordinate: coordinate, timestamp: timestamp))
            }
            
            print("\nrouteCoor: \(routeCoor)\n")

            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.regionCenterLatitude, longitude: location.regionCenterLongitude),
                span: MKCoordinateSpan(latitudeDelta: location.regionSpanLatitude, longitudeDelta: location.regionSpanLongitude)
            )
            
            print("\nregion: \(region)\n")

            let saveLoc = SaveLoc(
                routeCoordinates: routeCoor,
                pins: pinLoc,
                sliderValue: location.sliderValue,
                showSlider: location.showSlider,
                region: region,
                maxSliderValue: location.maxSliderValue
            )
            
            print("\nsaveLoc: \(saveLoc)\n")
            
            model.storeLocation.append(saveLoc)
            print("\nstoreLoc: \(model.storeLocation.count)\n")
        }
    }
}
