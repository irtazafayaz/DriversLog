//
//  TripDetailView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI
import GoogleMaps

struct TripDetailView: View {
    
    @State private var openLegendView: Bool = false
    @State private var showMapView: Bool = false
    @ObservedObject private var findAddressVM: FindAddressManager = FindAddressManager()
    
    private let selectedTrip: TripItem

    init(selectedTrip: TripItem) {
        self.selectedTrip = selectedTrip
    }
    
    private func isNight() -> Bool {
        return selectedTrip.dayOrNight == "Day" ? false : true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Image(systemName: isNight() ? "moon.fill" : "sun.min.fill")
                    .font(.title)
                Text("\(selectedTrip.tripDate)")
            }
            .padding()
            
            //MARK: Starting | Ending points
            
            HStack {
                VStack(spacing: 0) {
                    Image(systemName: "circle")
                        .font(.title)
                    Rectangle()
                            .frame(width: 5, height: 50)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .alignmentGuide(.top) { _ in -10 }
                    ZStack {
                        Image(systemName: "circle.fill")
                        Image(systemName: "circle")
                            .font(.title)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("\(findAddressVM.startAddress)")
                    Text("\(selectedTrip.startTime)")
                        .foregroundStyle(.gray)
                    
                    Text("\(findAddressVM.endAddress)")
                        .padding(.top, 10)
                    Text("\(selectedTrip.endTime)")
                        .foregroundStyle(.gray)
                    
                }
                .padding(.leading, 20)
            }
            .padding()
            
            Divider()
            
            //MARK: Duration
            
            HStack {
                Image(systemName: "clock")
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Duration:")
                            .bold()
                        Text("\(selectedTrip.duration)")
                    }
                }
                .padding(.leading, 20)
                
            }
            .padding()
            
            Divider()

            //MARK: TODO
            
            HStack {
                Text("S")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(5)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("B")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(5)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("ML")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(5)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("M")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(5)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("D")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(5)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .frame(maxWidth: .infinity)
            .padding()

            Spacer()
            
            VStack(spacing: 10) {
                Button {
                    showMapView = true
                } label: {
                    HStack {
                        Text("View Route")
                            .foregroundStyle(.white)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Button {
                    openLegendView.toggle()
                } label: {
                    HStack {
                        Text("View Legend")
                            .foregroundStyle(.white)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .frame(maxWidth: .infinity)

        }
        .onAppear {
            findAddressVM.fetchAddresses(for: selectedTrip)
        }
        .navigationDestination(isPresented: $openLegendView, destination: {
            TripLegendView()
        })
        .navigationDestination(isPresented: $showMapView, destination: {
            if let coordinates = selectedTrip.pathPoints?.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }) {
                ViewRouteMap(coordinates: coordinates)
            }
        })
        .background(Color("app-background"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.black)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                HStack {
                    BackButton()
                    Text("Trip# 8")
                        .foregroundStyle(.white)
                }
            })
        }
    }
}

