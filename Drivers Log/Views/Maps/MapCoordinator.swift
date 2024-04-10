//
//  MapCoordinator.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 09/04/2024.
//

import Foundation
import CoreLocation
import GoogleMaps
import Firebase
import SwiftUI

class MapCoordinator: NSObject, CLLocationManagerDelegate {
    
    var mapView: GMSMapView?
    var locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var polyline: GMSPolyline?
    var locationsArray = [CLLocation]()
    var startTime: Date?
    var totalDistance: CLLocationDistance = 0
    
    func startLocationUpdates() {
        self.totalDistance = 0
        locationsArray.removeAll()
        startTime = Date()
        locationManager.startUpdatingLocation()
        previousLocation = nil
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        saveDrivingSessionToFirebase()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        locationsArray.append(location)
        
        
        if let previousLocation = self.previousLocation {
            let distance = location.distance(from: previousLocation)
            self.totalDistance += distance
        }
        
        if let path = polyline?.path {
            let mutablePath = GMSMutablePath(path: path)
            mutablePath.add(location.coordinate)
            polyline?.path = mutablePath
        } else {
            let path = GMSMutablePath()
            path.add(location.coordinate)
            
            let newPolyline = GMSPolyline(path: path)
            newPolyline.strokeColor = .red
            newPolyline.strokeWidth = 5.0
            newPolyline.map = mapView
            polyline = newPolyline
        }
        
        let zoom: Float = 18.0
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
        mapView?.animate(to: camera)
        self.previousLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
        }
    }
    
    func saveDrivingSessionToFirebase() {
        let endTime = Date()
        
        // Convert locations to PathModel instances
        let pathPoints: [PathModel] = locationsArray.map { location in
            return PathModel(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
        
        // Format start and end times
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let startTimeString = dateFormatter.string(from: startTime ?? Date())
        let endTimeString = dateFormatter.string(from: endTime)
        
        // Format trip date
        dateFormatter.dateFormat = "dd MMM,yyyy"
        let tripDateString = dateFormatter.string(from: startTime ?? Date())
        
        // Calculate duration
        let duration = endTime.timeIntervalSince(startTime ?? Date())
        let durationHours = Int(duration) / 3600
        let durationMinutes = (Int(duration) % 3600) / 60
        let durationSeconds = Int(duration) % 60
        let durationString = String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
        
        // Calculate total distance in kilometers
        let totalDistanceKilometers = String(format: "%.2f", totalDistance / 1000)
        
        // Create TripItem instance
        let tripItem = TripItem(
            tripTotalDistance: totalDistanceKilometers,
            startTime: startTimeString,
            endTime: endTimeString,
            duration: durationString,
            tripDate: tripDateString,
            pathPoints: pathPoints
        )
        
        // Encode TripItem and set data in Firestore
        let databaseReference = Firestore.firestore()
        let documentReference = databaseReference.collection("drivingSessions").document()
        
        try? documentReference.setData(from: tripItem) { error in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
}
