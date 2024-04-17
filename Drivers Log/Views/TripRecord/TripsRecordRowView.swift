//
//  TripsRecordRowView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct TripsRecordRowView: View {
    
    let trip: TripItem
    
    private func isNight() -> Bool {
        return trip.dayOrNight == "Day" ? false : true
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: isNight() ? "moon.fill" : "sun.min.fill")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text(trip.tripTitle)
                        .bold()
                    HStack {
                        Text("\(trip.duration)")
                        Text("|")
                        Text("\(trip.tripTotalDistance) KM")
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Text("\(trip.tripDate)")
                
            }
            .padding()
            
            Divider()
        }
    }
    
}
