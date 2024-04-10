//
//  FindAddressManager.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/04/2024.
//

import Foundation
import CoreLocation
import GoogleMaps

final class FindAddressManager: ObservableObject {
    
    @Published var startAddress: String = ""
    @Published var endAddress: String = ""
    
    func fetchAddresses(for tripItem: TripItem) {
        guard let pathPoints = tripItem.pathPoints, !pathPoints.isEmpty else { return }
        
        let startCoordinate = pathPoints.first
        let endCoordinate = pathPoints.last
        
        geocode(coordinate: startCoordinate) { [weak self] address in
            self?.startAddress = address
        }
        geocode(coordinate: endCoordinate) { [weak self] address in
            self?.endAddress = address
        }
    }
    
    private func geocode(coordinate: CoordinatesModel?, completion: @escaping (String) -> Void) {
        guard let coordinate = coordinate,
              let latitude = Double(coordinate.latitude),
              let longitude = Double(coordinate.longitude) else { return }
        
        let geocoder = GMSGeocoder()
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            guard error == nil else {
                print("Reverse geocoding failed: \(error!.localizedDescription)")
                completion("")
                return
            }
            
            if let address = response?.firstResult(), let lines = address.lines {
                completion(lines.joined(separator: "\n"))
            } else {
                completion("Address not found")
            }
        }
    }
    
    
    
}
