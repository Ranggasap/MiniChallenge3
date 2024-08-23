//
//  SavedLocation.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 20/08/24.
//

import Foundation
import CoreLocation
import MapKit

import SwiftData

struct SaveLoc: Identifiable {
    var id = UUID()
    var routeCoordinates: [(coordinate: CLLocationCoordinate2D, timestamp: Date)]
    var pins: [PinLocation]
    var sliderValue: Double
    var showSlider: Bool
    var region: MKCoordinateRegion
    var maxSliderValue: Double
    var streetName: String
    var streetDetail: String
}

@Model
class SavedLocation {
    var id = UUID()
    @Relationship(deleteRule: .cascade) var routeCoordinates = [RouteCoordinate]()
    @Relationship(deleteRule: .cascade) var pinnedLocations = [PinnedLocation]()
    var sliderValue: Double
    var showSlider: Bool
    var regionCenterLatitude: Double
    var regionCenterLongitude: Double
    var regionSpanLatitude: Double
    var regionSpanLongitude: Double
    var maxSliderValue: Double
    var streetName: String
    var streetDetail: String
    
    init(id: UUID = UUID(), sliderValue: Double, showSlider: Bool, regionCenterLatitude: Double, regionCenterLongitude: Double, regionSpanLatitude: Double, regionSpanLongitude: Double, maxSliderValue: Double, streetName: String, streetDetail: String) {
        self.id = id
        self.sliderValue = sliderValue
        self.showSlider = showSlider
        self.regionCenterLatitude = regionCenterLatitude
        self.regionCenterLongitude = regionCenterLongitude
        self.regionSpanLatitude = regionSpanLatitude
        self.regionSpanLongitude = regionSpanLongitude
        self.maxSliderValue = maxSliderValue
        self.streetName = streetName
        self.streetDetail = streetDetail
    }
    
    func insert(_ context: ModelContext) {
        context.insert(self)
    }
    
    func delete(_ context: ModelContext) {
        context.delete(self)
    }
}

@Model
class RouteCoordinate {
    var routeLatitude: Double
    var routeLongitude: Double
    var routeTimestamp: Double // date
    var savedLocation: SavedLocation?
    
    init(routeLatitude: Double, routeLongitude: Double, routeTimestamp: Double) {
        self.routeLatitude = routeLatitude
        self.routeLongitude = routeLongitude
        self.routeTimestamp = routeTimestamp
    }
}

@Model
class PinnedLocation {
    var pinLatitude: Double
    var pinLongitude: Double
    var pinDate: Double // date
    var savedLocation: SavedLocation?
    
    init(pinLatitude: Double, pinLongitude: Double, pinDate: Double) {
        self.pinLatitude = pinLatitude
        self.pinLongitude = pinLongitude
        self.pinDate = pinDate
    }
}
