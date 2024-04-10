//
//  MapView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 03/04/2024.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: UIViewRepresentable {

    @Binding var totalDistance: CLLocationDistance
    var coordinator = MapCoordinator()
    
    func makeCoordinator() -> MapCoordinator {
           return coordinator
       }
    
    func startMoving() {
        let coordinator = makeCoordinator()
        coordinator.startLocationUpdates()
    }

    func stopMoving() {
        let coordinator = makeCoordinator()
        coordinator.stopLocationUpdates()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        context.coordinator.mapView = mapView
        context.coordinator.locationManager.requestWhenInUseAuthorization()
        context.coordinator.locationManager.delegate = context.coordinator
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}
