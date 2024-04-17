//
//  DriverRouteModel.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 09/04/2024.
//

import Foundation
import FirebaseFirestore

struct CoordinatesModel: Codable {
    let latitude: String
    let longitude: String
}

struct TripItem: Identifiable, Codable {
    @DocumentID var id: String?
    
    var tripTitle           : String = "Paris"
    var startLocation       : String = ""
    var endLocation         : String = ""
    var tripTotalDistance   : String
    var startTime           : String = "00:00:00"
    var endTime             : String = "12:00:00"
    var duration            : String = "12:60:60"
    var tripDate            : String = "16 Dec,2024"
    var pathPoints          : [CoordinatesModel]?
    var dayOrNight          : String = "Day"
    
    
    
    private enum CodingKeys: String, CodingKey {
        case tripTitle, startLocation, endLocation, tripTotalDistance, startTime, endTime, duration, tripDate, pathPoints, dayOrNight
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripTitle, forKey: .tripTitle)
        try container.encode(startLocation, forKey: .startLocation)
        try container.encode(endLocation, forKey: .endLocation)
        try container.encode(tripTotalDistance, forKey: .tripTotalDistance)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(tripDate, forKey: .tripDate)
        try container.encode(pathPoints, forKey: .pathPoints)
        try container.encode(dayOrNight, forKey: .dayOrNight)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tripTitle = try container.decode(String.self, forKey: .tripTitle)
        startLocation = try container.decode(String.self, forKey: .startLocation)
        endLocation = try container.decode(String.self, forKey: .endLocation)
        tripTotalDistance = try container.decode(String.self, forKey: .tripTotalDistance)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)
        duration = try container.decode(String.self, forKey: .duration)
        tripDate = try container.decode(String.self, forKey: .tripDate)
        pathPoints = try container.decodeIfPresent([CoordinatesModel].self, forKey: .pathPoints)
        dayOrNight = try container.decode(String.self, forKey: .dayOrNight)
    }
    
    init(
        tripTotalDistance: String,
        startTime: String,
        endTime: String,
        duration: String,
        tripDate: String,
        pathPoints: [CoordinatesModel]?,
        dayOrNight: String
    ) {
        self.tripTotalDistance = tripTotalDistance
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.tripDate = tripDate
        self.pathPoints = pathPoints
        self.dayOrNight = dayOrNight
    }
    
}
