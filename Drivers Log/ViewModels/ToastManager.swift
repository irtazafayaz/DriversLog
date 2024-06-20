//
//  ToastManager.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 26/05/2024.
//

import Foundation
import Combine
import SwiftUI

class ToastManager: ObservableObject {
    @Published var showToast: Bool = false
    @Published var message: String = ""
    
    func show(message: String, duration: TimeInterval = 2) {
        self.message = message
        self.showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.showToast = false
            }
        }
    }
}
