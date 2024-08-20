//
//  iOSLocationView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import CoreLocation
//import MapKit

struct iOSLocationView: View {
    @StateObject var model = LocationManager()
    @State private var isNavigate = false

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
                
                if !isNavigate {
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
                }
            }
            .onChange(of: model.showSlider) { _, newValue in
                if model.showSlider && model.routeCoordinates.count > 1 {
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
