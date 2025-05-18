//
//  StreakData.swift
//  Hydrate+
//
//  Created by Ian   on 16/05/2025.
//

/*
StreakData represents the user's water intake streak tracking in the Hydrate+ app.
This model stores:
 - currentStreak: The number of consecutive days the user has met their daily water intake goal
 - lastUpdated: The timestamp of the last streak update
 - dailyGoal: The user's daily water intake target in milliliters

This data structure is used to track and maintain user engagement through streak-based  achievements,
encouraging consistent water intake habits.
 */

import Foundation
import FirebaseFirestore

struct StreakData: Codable {
    var currentStreak: Int
    var lastUpdated: Date
    var dailyGoal: Double
    
    init(currentStreak: Int = 0, lastUpdated: Date = Date(), dailyGoal: Double = 2000) {
        self.currentStreak = currentStreak
        self.lastUpdated = lastUpdated
        self.dailyGoal = dailyGoal
    }
}
