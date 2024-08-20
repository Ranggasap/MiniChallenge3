//
//  RoutePolyline.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import SwiftUI
import MapKit

struct RoutePolyline: UIViewRepresentable {
    var routeCoordinates: [CLLocationCoordinate2D]
    var startEndPins: (start: PinLocation?, end: PinLocation?)

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)

        if !routeCoordinates.isEmpty {
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)
        }

        if let startPin = startEndPins.start {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = startPin.coordinate
            startAnnotation.title = "Start"
            mapView.addAnnotation(startAnnotation)
        }

        if let endPin = startEndPins.end {
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = endPin.coordinate
            endAnnotation.title = "End"
            mapView.addAnnotation(endAnnotation)
        }
    }

    func makeCoordinator() -> lineCoordinator {
        lineCoordinator(self)
    }
}
