//
//  DriverRouteModel.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 09/04/2024.
//

import Foundation
import FirebaseFirestore

struct PathModel: Codable {
    let latitude: String
    let longitude: String
}

struct TripItem: Identifiable, Codable {
    @DocumentID var id: String?
    
    var tripTitle: String = "Paris"
    var startLocation: String = ""
    var endLocation: String = ""
    var tripTotalDistance: String
    var startTime: String="00:00:00"
    var endTime: String="12:00:00"
    var duration: String="12:60:60"
    var tripDate: String = "16 Dec,2024"
    var pathPoints: [PathModel]?
    var dayOrNight: String = "Day"
}
