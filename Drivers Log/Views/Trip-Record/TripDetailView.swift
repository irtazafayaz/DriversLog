//
//  TripDetailView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct TripDetailView: View {
    
    @State private var openLegendView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Image(systemName: "moon.fill")
                    .font(.title)
                Text("Dec 19, 2020")
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
                    Text("Churchil SHopping Center,\nChurchil SHopping Center")
                    Text("08:06 PM")
                        .foregroundStyle(.gray)
                    
                    Text("Churchil SHopping Center,\nChurchil SHopping Center")
                        .padding(.top, 10)
                    Text("08:06 PM")
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
                        Text("0:55:50")
                    }
                    HStack {
                        Text("Duration:")
                            .bold()
                        Text("0:55:50")
                    }
                    
                }
                .padding(.leading, 20)
                
            }
            .padding()
            
            Divider()

            //MARK: Dont know
            
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
        .navigationDestination(isPresented: $openLegendView, destination: {
            TripLegendView()
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

#Preview {
    TripDetailView()
}
