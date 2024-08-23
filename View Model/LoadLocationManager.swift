//
//  LoadLocationManager.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 20/08/24.
//

import Combine
import CoreLocation
import MapKit
import AVFoundation

class LoadLocationManager: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var pins: [PinLocation] = []
    @Published var routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)] = []
    @Published var sliderValue: Double = 0
    @Published var showSlider = false
    @Published var player: Player
    @Published var lastGeocodedAddressName: String
    @Published var lastGeocodedAddressDetail: String
    @Published var lastGeocodedCoordinate: CLLocationCoordinate2D?
    var audioPlayer: AVPlayer?
    var timer: Timer?
    var maxSliderValue: Double
    
    init(region: MKCoordinateRegion, pins: [PinLocation], routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)], sliderValue: Double, showSlider: Bool, audioPlayer: AVPlayer? = nil, maxSliderValue: Double, lastGeocodedAddressName: String, lastGeocodedAddressDetail: String) {
        self.region = region
        self.pins = pins
        self.routeCoordinates = routeCoordinates
        self.sliderValue = sliderValue
        self.showSlider = showSlider
        self.audioPlayer = audioPlayer
        self.maxSliderValue = maxSliderValue
        self.player = Player(avPlayer: AVPlayer(url: Bundle.main.url(forResource: "testSong", withExtension: "mp3")!))
        self.lastGeocodedAddressName = lastGeocodedAddressName
        self.lastGeocodedAddressDetail = lastGeocodedAddressDetail
    }
    
    func updateRegionForEntireRoute() {
        guard !routeCoordinates.isEmpty else { return }
        let coordinates = routeCoordinates.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let mapRect = polyline.boundingMapRect
        region = MKCoordinateRegion(mapRect)
    }
    
    func updateRegionForEntireRouteForSlider() -> MKCoordinateRegion {
        guard !routeCoordinates.isEmpty else {
            // Return a default region if routeCoordinates is empty
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), // Default center (e.g., London)
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Default span
            )
        }
        
        let coordinates = routeCoordinates.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let mapRect = polyline.boundingMapRect
        return MKCoordinateRegion(mapRect)
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
        return sliderValue
    }
    
    func playAudio(fromTimestamp timestamp: TimeInterval) {
        player.scrubState = .scrubEnded(timestamp)
        player.play()
    }
    
    func pauseAudio() {
        player.pause()
    }
    
    func getClosestLocation(to targetTimestamp: Date) -> (coordinate: CLLocationCoordinate2D, timestamp: Date)? {
        return routeCoordinates.min(by: { abs($0.timestamp.timeIntervalSince(targetTimestamp)) < abs($1.timestamp.timeIntervalSince(targetTimestamp)) })
    }
    
    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error during reverse geocoding: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                completion(nil)
                return
            }
            
            self.lastGeocodedAddressName = ""
            self.lastGeocodedAddressDetail = ""
            
            // Construct a formatted address string
            if let street = placemark.thoroughfare, let city = placemark.locality, let country = placemark.country {
                self.lastGeocodedAddressName += street + ", " + city + ", " + country
            } else if let name = placemark.name {
                self.lastGeocodedAddressName += name
            } else {
                self.lastGeocodedAddressName += "Address information not available."
            }
            
            if let name = placemark.name {
                self.lastGeocodedAddressDetail += name + ", "
            }
            if let street = placemark.thoroughfare {
                self.lastGeocodedAddressDetail += street + ", "
            }
            if let subLocality = placemark.subLocality {
                self.lastGeocodedAddressDetail += subLocality + ", "
            }
            if let city = placemark.locality {
                self.lastGeocodedAddressDetail += city + ", "
            }
            if let state = placemark.administrativeArea {
                self.lastGeocodedAddressDetail += state + ", "
            }
            if let postalCode = placemark.postalCode {
                self.lastGeocodedAddressDetail += postalCode + ", "
            }
            if let country = placemark.country {
                self.lastGeocodedAddressDetail += country
            }
            
            completion(self.lastGeocodedAddressName.isEmpty ? "Address information not available." : self.lastGeocodedAddressName)
        }
    }

    
    func isCoordinate(_ coordinate1: CLLocationCoordinate2D, closeTo coordinate2: CLLocationCoordinate2D, threshold: CLLocationDistance = 50) -> Bool {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        return location1.distance(from: location2) <= threshold
    }

    
    func outputSliderValueLocationData() {
        // Get the exact coordinate at the current slider value
        guard let firstTimestamp = routeCoordinates.first?.timestamp else {
            print("No location data available.")
            return
        }
        
        // Calculate the target timestamp as a Date object
        let targetTimestamp = firstTimestamp.addingTimeInterval(sliderValue)
        
        // Get the closest location to the slider value
        if let closestLocation = getClosestLocation(to: targetTimestamp) {
            let latitude = closestLocation.coordinate.latitude
            let longitude = closestLocation.coordinate.longitude
            
            // Check if the new coordinate is close enough to the last geocoded coordinate
            if let lastCoordinate = lastGeocodedCoordinate,
               isCoordinate(closestLocation.coordinate, closeTo: lastCoordinate) {
            } else {
                // Perform reverse geocoding
                reverseGeocodeLocation(closestLocation.coordinate) { [weak self] _ in
                    if let self = self {
                        self.lastGeocodedCoordinate = closestLocation.coordinate
                    }
                }
            }
        } else {
            print("No location data available for the current slider value.")
        }
    }




}
