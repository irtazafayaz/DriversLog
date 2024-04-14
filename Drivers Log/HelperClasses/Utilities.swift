//
//  Utilities.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 15/04/2024.
//

import Foundation

class DateUtility {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static func formatDate(date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func formatDuration(from startTime: Date, to endTime: Date) -> String {
        let duration = endTime.timeIntervalSince(startTime)
        let durationHours = Int(duration) / 3600
        let durationMinutes = (Int(duration) % 3600) / 60
        let durationSeconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
    }
    
    static func formatDistanceInKilometers(distance: Double) -> String {
        return String(format: "%.2f", distance / 1000)
    }
    
    static func determineDayOrNight(from date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        if hour >= 6 && hour < 18 {
            return "Day"
        } else {
            return "Night"
        }
    }
    
}
