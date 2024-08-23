//
//  SwiftUIView.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 20/08/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct iOSLocationViewDetail: View {
    @ObservedObject var model: LoadLocationManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Location Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))
            
            Button(
                action: { model.pauseAudio() },
                label: {
                    VStack {
                        Image(systemName: "stop.circle")
                    }
                })
            .font(.title)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            RoutePolyline(routeCoordinates: model.routeUpToSliderValue(), startEndPins: model.startEndPinLocations())
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            
            if model.showSlider && model.routeCoordinates.count > 1 {
                Slider(
                    value: Binding(
                        get: {
                            model.sliderValue
                        },
                        set: { newValue in
                            model.sliderValue = newValue
                            model.player.scrubState = .scrubEnded(newValue)
                            if let timestamp = model.timestampForSliderValue() {
                                model.playAudio(fromTimestamp: timestamp)
                                if !model.updateRegionForEntireRouteForSlider().isEqualTo(model.region) {
                                    model.updateRegionForEntireRoute()  // Update the region based on the new location
                                }
                            }
                        }
                    ),
                    in: 0...model.maxSliderValue
                )
                .padding()
                .onChange(of: model.player.displayTime) { _, newValue in
                    model.sliderValue = newValue
                    model.outputSliderValueLocationData()
                }
                
                Button(action: {
                    model.player.togglePlayPause()
                }) {
                    Image(systemName: model.player.isPlaying ? "pause" : "play")
                        .imageScale(.large)
                        .frame(width: 64, height: 64)
                }
            }
        }
    }
}

extension MKCoordinateRegion {
    func isEqualTo(_ other: MKCoordinateRegion) -> Bool {
        return self.center.latitude == other.center.latitude &&
        self.center.longitude == other.center.longitude &&
        self.span.latitudeDelta == other.span.latitudeDelta &&
        self.span.longitudeDelta == other.span.longitudeDelta
    }
}
