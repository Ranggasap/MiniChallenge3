//
//  PinLocation.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import CoreLocation

struct PinLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
}
