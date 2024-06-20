//
//  Toast.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 26/05/2024.
//

import SwiftUI

struct Toast: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
            .shadow(radius: 10)
            .transition(.slide)
            .animation(.easeInOut)
    }
}

#Preview {
    Toast(message: "hello")
}
