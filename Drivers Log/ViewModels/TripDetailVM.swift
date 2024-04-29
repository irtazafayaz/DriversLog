//
//  TripDetailVM.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 09/04/2024.
//

import Foundation
import FirebaseAuth
import Firebase

final class TripDetailVM: ObservableObject {
    
    @Published private(set) var trips: [TripItem] = []
    private let databaseReference = Firestore.firestore()
    @Published var isLoading: Bool = false
    
    func fetchTrips(_ uid: String) {
        isLoading = true
        databaseReference.collection("user-data").document(uid).collection("trips")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                isLoading = false
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching trips: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                let trips = documents.compactMap { document -> TripItem? in
                    try? document.data(as: TripItem.self)
                }
                self.trips = trips
            }
    }

    
}
