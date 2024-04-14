//
//  TripsReportView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 13/04/2024.
//

import SwiftUI

import SwiftUI

struct TripsReportView: View {
    
    var tripItems: [TripItem]
    
    var body: some View {
        List(tripItems, id: \.id) { item in
            Section(header: Text("Trip to \(item.tripTitle) on \(item.tripDate)")) {
                HStack {
                    Text("Start Location:")
                    Spacer()
                    Text(item.startLocation)
                }
                HStack {
                    Text("End Location:")
                    Spacer()
                    Text(item.endLocation)
                }
                HStack {
                    Text("Total Distance:")
                    Spacer()
                    Text(item.tripTotalDistance)
                }
                HStack {
                    Text("Start Time:")
                    Spacer()
                    Text(item.startTime)
                }
                HStack {
                    Text("End Time:")
                    Spacer()
                    Text(item.endTime)
                }
                HStack {
                    Text("Duration:")
                    Spacer()
                    Text(item.duration)
                }
                HStack {
                    Text("Day or Night:")
                    Spacer()
                    Text(item.dayOrNight)
                }
            }
        }
        .navigationTitle("Trip Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export as CSV") {
                    let csvData = convertToCSV(tripItems: tripItems)
                    saveCSVFile(data: csvData)
                }
            }
        }
        
    }
    
    func convertToCSV(tripItems: [TripItem]) -> String {
        let csvHeader = "ID, Trip Title, Start Location, End Location, Total Distance, Start Time, End Time, Duration, Date, Day or Night\n"
        var csvString = csvHeader
        
        for trip in tripItems {
            let csvRow = "\(trip.id ?? ""),\(trip.tripTitle),\(trip.startLocation),\(trip.endLocation),\(trip.tripTotalDistance),\(trip.startTime),\(trip.endTime),\(trip.duration),\(trip.tripDate),\(trip.dayOrNight)\n"
            csvString += csvRow
        }
        
        return csvString
    }
    
    func saveCSVFile(data: String) {
        let fileName = "TripDetails.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do {
            try data.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let documentPicker = UIDocumentPickerViewController(forExporting: [path!])
            UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
        } catch {
            print("Failed to save file: \(error)")
        }
    }

    
}


#Preview {
    TripsReportView(tripItems: [TripItem(tripTotalDistance: "10")])
}
