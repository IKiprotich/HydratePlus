//
//  User.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

/*
 * User.swift
 * Hydrate+
 *
 * This file defines the core User model for the Hydrate+ app, which manages user data and preferences
 * for water intake tracking. The User struct implements Identifiable, Codable, and Equatable protocols
 * to support SwiftUI views, data persistence, and comparison operations.
 *
 * Key features:
 * - Basic user information (id, email, name, profile image)
 * - Water intake tracking (daily goal, current intake, daily average)
 * - User preferences (units, language, dark mode, notifications)
 * - Premium features and achievements tracking
 * - Streak tracking for consistent water intake
 */

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    let fullname: String
    var profileImageUrl: String?
    
    // Additional user properties with default values
    var memberSince: Date = Date()
    var isPremium: Bool = false
    var dailyGoal: Double = 2000
    var currentIntake: Double = 0
    var streakDays: Int = 0
    var dailyAverage: Double = 0
    var achievementsCount: Int = 0
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var units: String { "Metric (ml)" }
    var language: String { "English" }
    var twoFactorEnabled: Bool { false }
    
 
    init(id: String, fullname: String, email: String) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.memberSince = Date()
        self.currentIntake = 0
    }
    
    // (for preview and testing)
    init(id: String, email: String, fullname: String, profileImageUrl: String? = nil,
         memberSince: Date = Date(), isPremium: Bool = false, dailyGoal: Double = 2000,
         currentIntake: Double = 0, streakDays: Int = 0, dailyAverage: Double = 0,
         achievementsCount: Int = 0, notificationsEnabled: Bool = true,
         darkModeEnabled: Bool = false) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
        self.memberSince = memberSince
        self.isPremium = isPremium
        self.dailyGoal = dailyGoal
        self.currentIntake = currentIntake
        self.streakDays = streakDays
        self.dailyAverage = dailyAverage
        self.achievementsCount = achievementsCount
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
    }
}

extension User {
    static var MOCK_USER = User(id: "1", fullname: "Tyreek Hill", email: "tyreekcheetah@gmail.com")
}
