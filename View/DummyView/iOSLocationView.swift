//
//  iOSLocationView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import CoreLocation
import SwiftData
import MapKit

struct iOSLocationView: View {
    @StateObject var model = LocationManager()
    @Environment(\.modelContext) var context
    @State private var isNavigate = false
    @Query(sort: \SavedLocation.id) var savedLocations: [SavedLocation]

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                Button(
                    action: {
                        model.startStopLocationTracking()
                    }, label: {
                        VStack {
                            Image(systemName: model.isLocationTrackingEnabled ? "stop" : "location")
                            Text(model.isLocationTrackingEnabled ? "Stop" : "Start")
                        }
                    })
                .font(.title)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                if !isNavigate && savedLocations == [] {
                    Text("Location Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))
                } else {
                    List(model.storeLocation) { savedLocation in
                        NavigationLink(
                            destination: iOSLocationViewDetail(model: LoadLocationManager(region: savedLocation.region, pins: savedLocation.pins, routeCoordinates: savedLocation.routeCoordinates, sliderValue: savedLocation.sliderValue, showSlider: savedLocation.showSlider, maxSliderValue: savedLocation.maxSliderValue))
                        ) {
                            Text(savedLocation.id.uuidString)
                                .font(.headline)
                        }
                    }
                    .onAppear {
                        if !isNavigate {
                            convertToTempData()
                        }
                    }
                }
            }
            .onChange(of: model.isDisabled) {
                if model.isDisabled {
                    storeLocationToSwiftData()
                    convertToTempData()
                }
            }
            .onChange(of: model.loadLocManager.showSlider) { _, newValue in
                if model.loadLocManager.showSlider && model.loadLocManager.routeCoordinates.count > 1 {
                    isNavigate = true
                }
            }
            .onAppear {
                if !model.isLocationTrackingEnabled {
                    model.updateRegionForEntireRoute()
                }
            }
                
        }
    }
}
