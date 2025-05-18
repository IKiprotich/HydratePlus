//
//  LeaderBoardEntry.swift
//  Hydrate+
//
//  Created by Ian   on 07/05/2025.
//

/// Represents a user's entry in the hydration leaderboard, tracking their water consumption progress.
/// This model is used to display and compare users' daily water intake achievements in the app's social features.

import Foundation

struct LeaderboardEntry: Identifiable {
    let id: String
    let name: String
    let totalConsumed: Double
    
    init(id: String, name: String, totalConsumed: Double) {
        self.id = id
        self.name = name
        self.totalConsumed = totalConsumed
    }
}
