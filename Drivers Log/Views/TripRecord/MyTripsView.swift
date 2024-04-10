//
//  MyTripsView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct MyTripsView: View {
    
    @State private var opentripDetailPage: Bool = false
    @State private var selectedTrip: TripItem?

    @ObservedObject private var viewModel = TripDetailVM()
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    ForEach(viewModel.trips, id: \.id) { trip in
                        TripsRecordRowView(trip: trip)
                            .onTapGesture {
                                selectedTrip = trip
                                opentripDetailPage.toggle()
                            }
                    }
                }
                Spacer()
            }
            .navigationDestination(isPresented: $opentripDetailPage, destination: { 
                if let trip = selectedTrip { TripDetailView(selectedTrip: trip) }
            })
            .onAppear {
                viewModel.fetchTrips(sessionManager.getCurrentAuthUser()?.uid ?? "NaN")
            }
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
    MyTripsView()
}
