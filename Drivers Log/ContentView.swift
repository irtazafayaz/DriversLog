//
//  ContentView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sessionManager = SessionManager()

    var body: some View {
        LoginView()
    }
}

#Preview {
    ContentView()
}
