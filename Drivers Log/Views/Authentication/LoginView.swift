//
//  LoginView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 03/04/2024.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var code: String = "+61"
    @State private var phoneNumber: String = ""
    @State private var uid: String = ""
    @State private var openOTPPage: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var error: MyError? = nil
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    Text("Login").font(.largeTitle).bold().foregroundStyle(.black)
                    Text("Enter your mobile number").font(.body).bold().foregroundStyle(.gray)
                    
                    HStack {
                        TextField("0000000000", text: $phoneNumber)
                            .padding()
                            .background(Color("app-background"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.top, 20)
                    
                    Button {
                        
                        if phoneNumber.count != 10 {
                            error = MyError.someError
                            showAlert = true
                        } else {
                            isLoading = true
                            
                            let trimmedPhoneNumber = String(phoneNumber.dropFirst())
                            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                            PhoneAuthProvider.provider().verifyPhoneNumber(self.code + trimmedPhoneNumber, uiDelegate: nil) { (id, err) in
                                isLoading = false
                                if err != nil {
                                    print("Error \(String(describing: err))")
                                } else {
                                    self.uid = id ?? "NaN"
                                    self.openOTPPage.toggle()
                                }
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
                    .alert(isPresented: $showAlert, error: error) { _ in
                        Button("OK") {
                            showAlert = false
                        }
                    } message: { error in
                        Text("Phone number is incorrect. Please enter a valid 10-digit phone number.")
                    }
                    
                    Spacer()
                    
                    Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                }
                .padding()
                .background(Color("app-background"))
                .navigationDestination(isPresented: $openOTPPage, destination: {
                    VerifyOTPView(uid: $uid)
                })
            }
            
            
            if isLoading {
                Color.black.opacity(0.6).ignoresSafeArea()
                ProgressView().tint(.white)
            }
            
        }
    }
}

#Preview {
    LoginView()
}

enum MyError: LocalizedError {
    case someError
    
    var errorDescription: String? {
        switch self {
        case .someError:
            return "Something went wrong"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .someError:
            return "Please try again."
        }
    }
}
