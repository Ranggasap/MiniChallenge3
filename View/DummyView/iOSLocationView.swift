//
//  iOSLocationView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct iOSLocationView: View {
    @StateObject var model = LocationManager()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Location Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))

            Button(
                action: { model.startStopLocationTracking() },
                label: {
                    VStack {
                        Image(systemName: model.isLocationTrackingEnabled ? "stop" : "location")
                        Text(model.isLocationTrackingEnabled ? "Stop" : "Start")
                    }
                })
            .font(.title)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
          
          Button(
              action: { model.pauseAudio() },
              label: {
                  VStack {
                      Image(systemName: "stop.circle")
                  }
              })
          .font(.title)
          .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))

            Map(coordinateRegion: $model.region, annotationItems: model.pins) { pin in
                MapPin(coordinate: pin.coordinate, tint: .red)
            }
            .overlay(
                RoutePolyline(routeCoordinates: model.routeUpToSliderValue(), startEndPins: model.startEndPinLocations())
            )
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))

            if model.showSlider && model.routeCoordinates.count > 1 {
                Slider(
                  value: $model.sliderValue,
                  in: 0...model.maxSliderValue,
                  step: 0.1
                )
                .padding()
                .onChange(of: model.sliderValue) {
                  if let timestamp = model.timestampForSliderValue() {
                      model.playAudio(fromTimestamp: timestamp)
                      model.updateRegionForEntireRoute()  // Update the region based on the new location
                  }
                }
            }
        }
        .onAppear {
            if !model.isLocationTrackingEnabled {
                model.updateRegionForEntireRoute()
            }
        }
    }
}
