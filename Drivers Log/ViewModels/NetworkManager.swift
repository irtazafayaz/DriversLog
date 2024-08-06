//
//  NetworkManager.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 25/06/2024.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class NetworkManager {
    
    private init() {}
    
    static let shared = NetworkManager()
    
    @Published var user: User?

}
