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