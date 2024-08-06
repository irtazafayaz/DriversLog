//
//  NewTripView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI
import FirebaseFunctions
import Firebase

struct NewTripView: View {
    
    @State private var supervisorPermitText: String = ""
    @State private var supervisorMobileNo: String = ""
    @State private var startTripButtonTapped: Bool = false
    @State private var uid: String = ""

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
                
                sendOtp()
                
                //startTripButtonTapped.toggle()
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
        .navigationDestination(isPresented: $startTripButtonTapped, destination: {
            VerifySupOTPView(phoneNumber: $supervisorMobileNo, uid: $uid)
        })
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
    
    private func sendOtp() {
        let trimmedPhoneNumber = String(supervisorMobileNo.dropFirst())
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber("+923104189309", uiDelegate: nil) { (id, err) in
            if err != nil {
                print("Error \(String(describing: err))")
            } else {
                self.uid = id ?? "NaN"
                startTripButtonTapped.toggle()

            }
        }
        
        //        let functions = Functions.functions()
        //        let trimmedPhoneNumber = String(supervisorMobileNo.dropFirst())
        //        let data = ["phoneNumber": "+923104189309"]
        //
        //        functions.httpsCallable("sendOtp").call(data) { result, error in
        //            DispatchQueue.main.async {
        //                if let error = error {
        //                    print("Failed to send OTP: \(error.localizedDescription)")
        //                    completion(false)
        //                    return
        //                }
        //
        //                if let status = (result?.data as? [String: Any])?["status"] as? String, status == "pending" {
        //                    // Assuming 'pending' means OTP sent successfully.
        //                    completion(true)
        //                } else {
        //                    completion(false)
        //                    print("Failed to send OTP: \(result?.data)")
        //                }
        //            }
        //        }
    }
}

#Preview {
    NewTripView()
}
