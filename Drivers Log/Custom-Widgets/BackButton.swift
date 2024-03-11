//
//  BackButton.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/03/2024.
//

import Foundation
import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.backward")
                .foregroundStyle(.white)
        }
    }
}
