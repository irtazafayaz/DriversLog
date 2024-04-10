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
    
    func fetchTrips(_ uid: String) {
        databaseReference.collection("drivingSessions")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error Fetching Driving Sessions")
                    return
                }
                let groups = documents.compactMap { document -> TripItem? in
                    try? document.data(as: TripItem.self)
                }
                trips = groups

            }
    }
    
}
