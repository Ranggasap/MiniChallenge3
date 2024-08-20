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
    @Published var pins: [PinLocation]
    @Published var routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)]
    @Published var sliderValue: Double
    @Published var showSlider: Bool
    var audioPlayer: AVPlayer?
    @Published var maxSliderValue: Double
    
    init(region: MKCoordinateRegion, pins: [PinLocation], routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)], sliderValue: Double, showSlider: Bool, audioPlayer: AVPlayer? = nil, maxSliderValue: Double) {
        self.region = region
        self.pins = pins
        self.routeCoordinates = routeCoordinates
        self.sliderValue = sliderValue
        self.showSlider = showSlider
        self.audioPlayer = audioPlayer
        self.maxSliderValue = maxSliderValue
    }
    
    func updateRegionForEntireRoute() {
        guard !routeCoordinates.isEmpty else { return }
        let coordinates = routeCoordinates.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let mapRect = polyline.boundingMapRect
        region = MKCoordinateRegion(mapRect)
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
