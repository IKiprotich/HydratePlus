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
    var progress: Int
    var streak: Int
    var timestamp: Date

    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
}
