//
//  NewTripView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct NewTripView: View {
    
    @State private var supervisorPermitText: String = ""
    @State private var supervisorMobileNo: String = ""

    var body: some View {
        VStack {
            
            TextField("Supervisor's Permit", text: $supervisorPermitText)
                .padding()
                .background(Color("app-background"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, minHeight: 50)
            
            TextField("Supervisor's Mobile No", text: $supervisorMobileNo)
                .padding()
                .background(Color("app-background"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, minHeight: 50)

            Button {
                
            } label: {
                Text("Send OTP")
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .frame(width: 200)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Spacer()
            
        }
        .padding()
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
    NewTripView()
}
