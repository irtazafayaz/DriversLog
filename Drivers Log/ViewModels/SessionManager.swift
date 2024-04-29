//
//  SessionManager.swift
//  DreamsApp
//
//  Created by Irtaza Fiaz on 18/03/2024.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

enum AuthState {
    case login
    case home
}

final class SessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    @Published var user: User?
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let firebaseUser = user {
                self.user = firebaseUser
                self.authState = .home
                self.saveUID(uid: firebaseUser.uid)
            } else {
                self.user = nil
                self.clearUID()
                self.goToLoginPage()
            }
        }
    }
    
    func saveUID(uid: String) {
            UserDefaults.standard.set(uid, forKey: "user-uid")
        }
        
        func getSavedUID() -> String? {
            UserDefaults.standard.string(forKey: "user-uid")
        }
        
        func clearUID() {
            UserDefaults.standard.removeObject(forKey: "user-uid")
        }
    
    func getCurrentAuthUser() -> User? {
        if let user = Auth.auth().currentUser {
            return user
        } else {
            return nil
        }
    }
    
    func logout() {
        do {
            clearUID()
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    
    func goToLoginPage() {
        DispatchQueue.main.async {
            self.authState = .login
        }
    }
}
