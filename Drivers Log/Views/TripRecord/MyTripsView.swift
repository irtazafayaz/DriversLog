//
//  MyTripsView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct MyTripsView: View {
    
    @State private var opentripDetailPage: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    ForEach(0...10, id: \.self) { index in
                        TripsRecordRowView()
                            .onTapGesture {
                                opentripDetailPage.toggle()
                            }
                    }
                }
            }
            .navigationDestination(isPresented: $opentripDetailPage, destination: { TripDetailView()
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
    MyTripsView()
}
