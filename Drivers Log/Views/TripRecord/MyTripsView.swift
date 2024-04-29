//
//  MyTripsView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct MyTripsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var opentripDetailPage: Bool = false
    @State private var selectedTrip: TripItem?
    private(set) var trips: [TripItem]
    
    init(trips: [TripItem]) {
        self.trips = trips
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if trips.count > 0 {
                    VStack {
                        ForEach(trips, id: \.id) { trip in
                            TripsRecordRowView(trip: trip)
                                .onTapGesture {
                                    selectedTrip = trip
                                    opentripDetailPage.toggle()
                                }
                        }
                    }
                    Spacer()
                } else {
                    Spacer()
                    Text("No Trips")
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity)
            .navigationDestination(isPresented: $opentripDetailPage, destination: {
                if let trip = selectedTrip { TripDetailView(selectedTrip: trip) }
            })
        }
        .background(Color("app-background"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.black)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                HStack {
                    BackButton()
                    Text("My Trips Record")
                        .foregroundStyle(.white)
                }
            })
        }
    }
}

#Preview {
    MyTripsView(trips: [])
}
