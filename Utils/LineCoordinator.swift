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
            renderer.strokeColor = .indicatorColor2
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "Here" {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.markerTintColor = .iconColor2
            annotationView.glyphImage = UIImage(named: "pinIconLogo")
            return annotationView
        }
        return nil
    }
}
