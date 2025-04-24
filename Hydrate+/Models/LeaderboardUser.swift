//
//  LeaderboardUser.swift
//  Hydrate+
//
//  Created by Ian   on 24/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct LeaderboardUser: Identifiable, Codable {
    @DocumentID var id: String?
    var fullname: String
    var progress: Int // Percentage of daily goal achieved
    var streak: Int
    var timestamp: Date // Last updated

    var isCurrentUser: Bool {
        // You can compare `id` with `Auth.auth().currentUser?.uid` in the ViewModel
        return id == Auth.auth().currentUser?.uid
    }
}
