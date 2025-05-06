//
//  LeaderboardViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 24/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LeaderboardViewModel: ObservableObject {
    @Published var users: [User] = []

    func loadLeaderboard() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .order(by: "currentIntake", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    return
                }
                print("Documents found: \(snapshot?.documents.count ?? 0)")
                snapshot?.documents.forEach { doc in
                    print("Document data: \(doc.data())")
                }

                guard let documents = snapshot?.documents else {
                    print("No users found")
                    return
                }

                self.users = documents.compactMap { doc in
                    let data = doc.data()
                    return User(
                        id: doc.documentID,
                        email: data["email"] as? String ?? "",
                        fullname: data["fullname"] as? String ?? "Unknown",
                        profileImageUrl: data["profileImageUrl"] as? String,
                        currenIntake: data["currentIntake"] as? Double ?? 0,
                        streakDays: data["streakDays"] as? Int ?? 0
                    )
                }
                print("Parsed users: \(self.users.map { $0.fullname })")
            }
    }
}
