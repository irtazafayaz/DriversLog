//
//  VerifySupOTPView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 02/05/2024.
//

import SwiftUI
import FirebaseFunctions

struct VerifySupOTPView: View {
    
    @Binding var phoneNumber: String
    @State private var code: String = ""
    @State private var openMap: Bool = false
    @State private var isLoading: Bool = false
    
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("OTP").font(.largeTitle).bold().foregroundStyle(.black)
                Text("Enter the code you received").font(.body).bold().foregroundStyle(.gray)
                
                HStack {
                    TextField("Enter OTP", text: $code)
                        .padding()
                        .background(Color("app-background"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                Button {
                    verifyOTP { success in
                        if success {
                            print("OTP SENT")
                        }
                    }
                    
                } label: {
                    Text("Login")
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .frame(width: 200)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 20)
                
                Spacer()
                
                
            }
            .padding()
            .background(Color("app-background"))
            .navigationDestination(isPresented: $openMap, destination: {
                DriverRouteView()
            })
            
            if isLoading {
                Color.black.opacity(0.6).ignoresSafeArea()
                ProgressView().tint(.white)
            }
            
        }
    }
    
    private func verifyOTP(completion: @escaping (Bool) -> Void) {
        isLoading = true
        let functions = Functions.functions()
        let data = ["phoneNumber": phoneNumber, "code": code]
        
        functions.httpsCallable("verifyOtp").call(data) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Failed to send OTP: \(error.localizedDescription)")
                    completion(false)
                    return
                } else {
                    openMap = true
                }
                
                
                
            }
        }
    }
    
}
