//
//  NewTripView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct NewTripView: View {
    var body: some View {
        VStack {
            Text("New Trip")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("app-background"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My Trips Record")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                BackButton()
            })
        }
    }
}

#Preview {
    NewTripView()
}
