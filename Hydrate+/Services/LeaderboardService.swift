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

    func fetchTopUsers(limit: Int = 20, completion: @escaping ([LeaderboardUser]) -> Void) {
        db.collection("users")
            .order(by: "progress", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let users = snapshot?.documents.compactMap { document in
                    try? document.data(as: LeaderboardUser.self)
                } ?? []

                completion(users)
            }
    }
}
