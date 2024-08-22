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
        ), pins: [], routeCoordinates: [], sliderValue: 0, showSlider: false, maxSliderValue: 0, lastGeocodedAddressName: "", lastGeocodedAddressDetail: "")
        
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
        loadLocManager.showSlider = false
        mgr.startUpdatingLocation()
    }
    
    func disable() {
        mgr.stopUpdatingLocation()
        updateRegionForEntireRoute()
        countMaxSliderValue()
        loadLocManager.sliderValue = loadLocManager.maxSliderValue
        loadLocManager.showSlider = true
        loadLocManager.outputSliderValueLocationData()
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
    
}

extension ContentView {
    func storeLocationToSwiftData() {
        if savedLocations.count >= 3 {
            savedLocations.last?.delete(context)
        }
        
        addNewItemToSwiftData()
    }
    
    private func addNewItemToSwiftData() {
        let savedLocation = createNewSavedLocation()
        savedLocation.insert(context)
        appendRouteCoordinates(to: savedLocation)
        appendPinnedLocations(to: savedLocation)
    }
    
    private func createNewSavedLocation() -> SavedLocation {
        return SavedLocation(
            sliderValue: locationVM.loadLocManager.sliderValue,
            showSlider: locationVM.loadLocManager.showSlider,
            regionCenterLatitude: locationVM.loadLocManager.region.center.latitude,
            regionCenterLongitude: locationVM.loadLocManager.region.center.longitude,
            regionSpanLatitude: locationVM.loadLocManager.region.span.latitudeDelta,
            regionSpanLongitude: locationVM.loadLocManager.region.span.longitudeDelta,
            maxSliderValue: locationVM.loadLocManager.maxSliderValue,
            streetName: locationVM.loadLocManager.lastGeocodedAddressName,
            streetDetail: locationVM.loadLocManager.lastGeocodedAddressDetail
        )
    }
    
    private func appendRouteCoordinates(to savedLocation: SavedLocation) {
        for location in locationVM.loadLocManager.routeCoordinates {
            let routeCoordinate = RouteCoordinate(
                routeLatitude: location.coordinate.latitude,
                routeLongitude: location.coordinate.longitude,
                routeTimestamp: location.timestamp.timeIntervalSince1970
            )
            savedLocation.routeCoordinates.append(routeCoordinate)
        }
    }
    
    private func appendPinnedLocations(to savedLocation: SavedLocation) {
        for pin in locationVM.loadLocManager.pins {
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
            if locationVM.storeLocation.contains(where: { $0.id == location.id }) {
                print("Location with id \(location.id) already exists in storeLocation. Skipping...")
                continue
            }
            
            var pinLoc: [PinLocation] = []
            var routeCoor: [(coordinate: CLLocationCoordinate2D, timestamp: Date)] = []
            
            for pin in location.pinnedLocations {
                let coordinate = CLLocationCoordinate2D(latitude: pin.pinLatitude, longitude: pin.pinLongitude)
                let timestamp = Date(timeIntervalSince1970: pin.pinDate)
                pinLoc.append(PinLocation(coordinate: coordinate, timestamp: timestamp))
            }
            pinLoc.sort(by: { $0.timestamp < $1.timestamp })
            
            for route in location.routeCoordinates {
                let coordinate = CLLocationCoordinate2D(latitude: route.routeLatitude, longitude: route.routeLongitude)
                let timestamp = Date(timeIntervalSince1970: route.routeTimestamp)
                routeCoor.append((coordinate: coordinate, timestamp: timestamp))
            }
            routeCoor.sort(by: { $0.timestamp < $1.timestamp })
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.regionCenterLatitude, longitude: location.regionCenterLongitude),
                span: MKCoordinateSpan(latitudeDelta: location.regionSpanLatitude, longitudeDelta: location.regionSpanLongitude)
            )
            
            let saveLoc = SaveLoc(
                id: location.id,
                routeCoordinates: routeCoor,
                pins: pinLoc,
                sliderValue: location.sliderValue,
                showSlider: location.showSlider,
                region: region,
                maxSliderValue: location.maxSliderValue,
                streetName: location.streetName,
                streetDetail: location.streetDetail
            )
            
            locationVM.storeLocation.append(saveLoc)
        }
    }
}
