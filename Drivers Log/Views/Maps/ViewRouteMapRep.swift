//
//  ViewRouteMapRep.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 09/04/2024.
//

import Foundation
import GoogleMaps
import SwiftUI

struct GoogleMapsView: UIViewRepresentable {
    var coordinates: [CLLocationCoordinate2D]

    // Create a GMSMapView and configure it
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        // Assuming coordinates are not empty, set the camera to the first coordinate
        if let first = coordinates.first {
            mapView.camera = GMSCameraPosition.camera(withLatitude: first.latitude, longitude: first.longitude, zoom: 15.0)
        }
        
        // Draw the route
        drawPath(on: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update the view if needed
    }

    // Function to draw the path on the map
    private func drawPath(on mapView: GMSMapView) {
        guard coordinates.count > 1 else { return }
        
        let path = GMSMutablePath()
        coordinates.forEach { path.add($0) }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 8.0
        polyline.strokeColor = .blue
        polyline.map = mapView
    }
}
