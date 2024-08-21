//
//  LineCoordinator.swift
//  MiniChallenge3
//
//  Created by Bryan Vernanda on 18/08/24.
//

import MapKit

class LineCoordinator: NSObject, MKMapViewDelegate {
    var parent: RoutePolyline

    init(_ parent: RoutePolyline) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.markerTintColor = annotation.title == "Start" ? .green : .red
        annotationView.glyphText = annotation.title == "Start" ? "S" : "E"
        return annotationView
    }
}
