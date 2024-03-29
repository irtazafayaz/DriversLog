//
//  HomeView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                NavigationLink(destination: NewTripView(), label: {
                    Text("New Trip")
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .frame(width: 200)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
                
                NavigationLink(destination: MyTripsView(), label: {
                    Text("My Trip")
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .frame(width: 200)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
                
                Button {
                    
                } label: {
                    Text("Print Report")
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .frame(width: 200)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Button {
                    
                } label: {
                    Text("Exit App")
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .frame(width: 200)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity)
            .background(Color("app-background"))
        }
        .background(Color("app-background"))

    }
}

#Preview {
    HomeView()
}
