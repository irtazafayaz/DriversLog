//
//  TripLegendView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct TripLegendView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack() {
                Text("Time")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
                
                HStack {
                    Text("D")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Day Time")
                    
                    Spacer()
                    
                    Text("N")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Night Time")
                }
                
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            
            VStack(alignment: .leading) {
            
                Text("Road Type")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
            
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("S")
                                .foregroundStyle(.white)
                                .bold()
                                .padding(7)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text("Sealed")
                        }
                        
                        HStack {
                            Text("Q")
                                .foregroundStyle(.white)
                                .bold()
                                .padding(7)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text("Quiet Street")
                        }
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("U")
                                .foregroundStyle(.white)
                                .bold()
                                .padding(7)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text("Unsealed")
                        }
                        
                        HStack {
                            Text("B")
                                .foregroundStyle(.white)
                                .bold()
                                .padding(7)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text("Busy")
                        }
                        
                    }
                    
                }
                
                HStack {
                    Text("ML")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Multi Laned")
                }
                
                
                
            
                
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            VStack() {
                Text("Traffic Density")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
                
                HStack {
                    Text("L")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Light")
                    
                    Spacer()
                    
                    Text("M")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Medium")
                    
                    Spacer()
                    
                    Text("H")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Heavy")
                }
                
            }
            .padding()
            
            VStack() {
                Text("Weather")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
                
                HStack {
                    Text("D")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Dry")
                    
                    Spacer()
                    
                    Text("W")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(7)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("Wet")
                }
                
            }
            .padding()
            
            Spacer()
            
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
                    Text("Legend")
                        .foregroundStyle(.white)
                }
            })
        }
    }
}

#Preview {
    TripLegendView()
}
