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

    var body: some View {
        VStack {
            
            Spacer()
            
            Text("OTP").font(.largeTitle).bold().foregroundStyle(.black)
            Text("Enter the code you received").font(.body).bold().foregroundStyle(.gray)
            
            HStack {
                TextField("+1", text: $code)
                    .padding()
                    .background(Color("app-background"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            
            Button {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.uid, verificationCode: self.code)
                Auth.auth().signIn(with: credential) { (res, err) in
                    if err != nil {
                        print("wrong code")
                    } else {
                        print("res \(res)")
                        
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
    }
}

