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
        guard let startTime = startTime else {
            print("Start time is nil.")
            return
        }
        
        let endTime = Date()
        let pathPoints: [CoordinatesModel] = locationsArray.map { location in
            return CoordinatesModel(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
        
        let tripItem = TripItem(
            tripTotalDistance: DateUtility.formatDistanceInKilometers(distance: totalDistance),
            startTime: DateUtility.formatDate(date: startTime, format: "HH:mm:ss"),
            endTime: DateUtility.formatDate(date: endTime, format: "HH:mm:ss"),
            duration: DateUtility.formatDuration(from: startTime, to: endTime),
            tripDate: DateUtility.formatDate(date: startTime, format: "dd MMM,yyyy"),
            pathPoints: pathPoints,
            dayOrNight:  DateUtility.determineDayOrNight(from: startTime)
        )
        
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
