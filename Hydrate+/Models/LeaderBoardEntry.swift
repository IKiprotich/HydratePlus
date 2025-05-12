//
//  LeaderBoardEntry.swift
//  Hydrate+
//
//  Created by Ian   on 07/05/2025.
//

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
