//
//  LeaderboardService.swift
//  Hydrate+
//
//  Created by Ian   on 24/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LeaderboardService {
    private let db = Firestore.firestore()

    func fetchTopUsers(limit: Int = 20, completion: @escaping ([User]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No authenticated user found.")
            completion([])
            return
        }

        db.collection("users")
            .order(by: "currentIntake", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let users: [User] = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return User(
                        id: doc.documentID,
                        email: data["email"] as? String ?? "",
                        fullname: data["fullname"] as? String ?? "Unknown",
                        profileImageUrl: data["profileImageUrl"] as? String,
                        currenIntake: data["currentIntake"] as? Double ?? 0,
                        streakDays: data["streakDays"] as? Int ?? 0
                    )
                } ?? []

                completion(users)
            }
    }
}
