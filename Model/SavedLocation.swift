//
//  SavedLocation.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 20/08/24.
//

import Foundation
import CoreLocation
import MapKit

struct SavedLocation: Identifiable {
    var id = UUID()
    var routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)]
    var pins: [PinLocation]
    var sliderValue: Double
    var showSlider: Bool
    var region: MKCoordinateRegion
    var maxSliderValue: Double
}
