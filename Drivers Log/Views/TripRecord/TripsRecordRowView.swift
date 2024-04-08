//
//  TripsRecordRowView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct TripsRecordRowView: View {
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: "moon.fill")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text("Trip# 12")
                        .bold()
                    HStack {
                        Text("0:00:13")
                        Text("|")
                        Text("0 KM")
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Text("Dec 19, 2020")
                
            }
            .padding()
            
            Divider()
        }
    }
    
}

#Preview {
    TripsRecordRowView()
}
