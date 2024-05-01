//
//  DriverRouteView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 03/04/2024.
//

import SwiftUI
import CoreLocation

struct DriverRouteView: View {
    
    @State private var totalDistance: CLLocationDistance = 0
    @State private var mapView = MapView(totalDistance: .constant(0))
    @State private var openLegendSelectionPage = false
    @State private var selectedTrip: TripItem?

    var body: some View {
        VStack {
            mapView
                .edgesIgnoringSafeArea(.all)

            Text("Total Distance: \(String(format: "%.2f", totalDistance)) meters")
                .padding()

            HStack {
                Button("Start Moving") {
                    mapView.startMoving()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Stop Moving") {
                    selectedTrip = mapView.stopMoving()
                    openLegendSelectionPage.toggle()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationDestination(isPresented: $openLegendSelectionPage, destination: {
            if let trip = selectedTrip {
                ChooseLegendView(tripInfo: trip)
            }
        })
    }
}



#Preview {
    DriverRouteView()
}
