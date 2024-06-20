//
//  ChooseLegendView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 01/05/2024.
//

import SwiftUI
import Firebase

struct ChooseLegendView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var time: String = "Day"
    @State private var road: String = "Sealed"
    @State private var traffic: String = "Light"
    @State private var weather: String = "Dry"
    @State private var isMultiLanedRoad: Bool = false
    
    @State var tripInfo: TripItem
    
    var body: some View {
        VStack {
            
            Text("Trip Environment")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Time")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            
            Picker("Time", selection: $time) {
                Text("Day").tag("Day")
                Text("Night").tag("Night")
            }.pickerStyle(SegmentedPickerStyle())
            
            Text("Road")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            Picker("Road", selection: $road) {
                Text("Sealed").tag("Sealed")
                Text("Unsealed").tag("Unsealed")
                Text("Quiet").tag("Quiet")
                Text("Busy").tag("Busy")
            }.pickerStyle(SegmentedPickerStyle())
            
            Toggle(isOn: $isMultiLanedRoad) {
                Text("Multi-Laned Road").bold()
            }
            .padding(.top, 10)
            
            Text("Traffic")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            Picker("Traffic", selection: $traffic) {
                Text("Light").tag("Light")
                Text("Medium").tag("Medium")
                Text("Heavy").tag("Heavy")
            }.pickerStyle(SegmentedPickerStyle())
            
            Text("Weather")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            Picker("Weather", selection: $weather) {
                Text("Dry").tag("Dry")
                Text("Wet").tag("Wet")
            }.pickerStyle(SegmentedPickerStyle())
            
            Button {
                saveSettings()
            } label: {
                Text("Save")
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .frame(width: 200)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }.padding(.top, 30)
            
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
                }
            })
        }
    }
    
    func saveSettings() {
        let uid = UserDefaults.standard.string(forKey: "user-uid") ?? "NaN"
        tripInfo.dayOrNight = time
        tripInfo.tripTitle = UserDefaults.standard.tripTitle
        tripInfo.roadType = road
        tripInfo.trafficDensity = traffic
        tripInfo.weather = weather
        tripInfo.multilane = isMultiLanedRoad ? "ML" : ""
        
        let databaseReference = Firestore.firestore()
        let documentReference = databaseReference.collection("users").document(uid).collection("trips").document()
        
        try? documentReference.setData(from: tripInfo) { error in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                NavigationUtil.popToRootView()
            }
        }
    }
    
}

// MARK: To pop back to the intial view
struct NavigationUtil {
    static func popToRootView(animated: Bool = false) {
        findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UITabBarController {
            return findNavigationController(viewController: navigationController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
