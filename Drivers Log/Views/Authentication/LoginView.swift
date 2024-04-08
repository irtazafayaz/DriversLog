//
//  LoginView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 03/04/2024.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var code: String = ""
    @State private var phoneNumber: String = ""
    @State private var uid: String = ""
    @State private var openOTPPage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("Login").font(.largeTitle).bold().foregroundStyle(.black)
                Text("Enter your mobile number").font(.body).bold().foregroundStyle(.gray)
                
                HStack {
                    TextField("+1", text: $code)
                        .frame(width: 45)
                        .padding()
                        .background(Color("app-background"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    TextField("999-999-999", text: $phoneNumber)
                        .padding()
                        .background(Color("app-background"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                Button {
                    PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.code + self.phoneNumber, uiDelegate: nil) { (id, err) in
                        
                        if err != nil {
                            print("Error \(String(describing: err))")
                        } else {
                            self.uid = id ?? "NaN"
                            self.openOTPPage.toggle()
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
            .navigationDestination(isPresented: $openOTPPage, destination: {
                VerifyOTPView(uid: $uid)
            })
        }
    }
}

#Preview {
    LoginView()
}
