//
//  LeaderboardService.swift
//  Hydrate+
//
//  Created by Ian   on 24/04/2025.
//

/*
 * LeaderboardService.swift
 * 
 * This service is a crucial component of Hydrate+ that manages the app's social and gamification features.
 * It handles the retrieval and management of user rankings based on their water intake achievements.
 * 
 * Key responsibilities:
 * - Fetches top users sorted by their current water intake
 * - Provides real-time leaderboard data for social engagement
 * - Integrates with Firebase Firestore for data persistence
 * - Supports user authentication and data security
 * 
 * The leaderboard feature encourages user engagement and healthy competition
 * by allowing users to compare their hydration progress with others.
 */

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
                        currentIntake: data["currentIntake"] as? Double ?? 0,
                        streakDays: data["streakDays"] as? Int ?? 0
                    )
                } ?? []

                completion(users)
            }
    }
}
