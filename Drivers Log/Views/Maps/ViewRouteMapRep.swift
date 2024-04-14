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

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        if let first = coordinates.first {
            mapView.camera = GMSCameraPosition.camera(withLatitude: first.latitude, longitude: first.longitude, zoom: 15.0)
        }
        
        drawPath(on: mapView)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}

    private func drawPath(on mapView: GMSMapView) {
        guard coordinates.count > 1 else { return }
        
        let path = GMSMutablePath()
        coordinates.forEach { path.add($0) }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 8.0
        polyline.strokeColor = .blue
        polyline.map = mapView
        
        if let firstCoordinate = coordinates.first {
            let firstMarker = GMSMarker(position: firstCoordinate)
            firstMarker.icon = GMSMarker.markerImage(with: .red)
            firstMarker.map = mapView
        }
        
        if let lastCoordinate = coordinates.last {
            let lastMarker = GMSMarker(position: lastCoordinate)
            lastMarker.icon = GMSMarker.markerImage(with: .red)
            lastMarker.map = mapView
        }
        
    }
}
