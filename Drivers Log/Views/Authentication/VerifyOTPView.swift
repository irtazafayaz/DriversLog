//
//  VerifyOTPView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 03/04/2024.
//

import SwiftUI
import Firebase

struct VerifyOTPView: View {
    
    @Binding var uid: String
    @State private var code: String = ""
    @State private var isLoading: Bool = false
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("OTP").font(.largeTitle).bold().foregroundStyle(.black)
                Text("Enter the code you received").font(.body).bold().foregroundStyle(.gray)
                
                HStack {
                    TextField("Enter code...", text: $code)
                        .padding()
                        .background(Color("app-background"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                Button {
                    isLoading = true
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.uid, verificationCode: self.code)
                    Auth.auth().signIn(with: credential) { (res, err) in
                        isLoading = false
                        if err != nil {
                            print("wrong code")
                        } else {
                            print("res \(String(describing: res))")
                            sessionManager.authState = .home
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
            
            if isLoading {
                Color.black.opacity(0.6).ignoresSafeArea()
                ProgressView().tint(.white)
            }
        }
        
    }
}

