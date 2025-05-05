//
//  User.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

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
    var currentIntake: Double
    var streakDays: Int = 0
    var achievementsCount: Int = 0
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var units: String { "Metric (ml)" }
    var language: String { "English" }
    var twoFactorEnabled: Bool { false }
    
    // Initialize with required fields only
    init(id: String, fullname: String, email: String) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.memberSince = Date()
        self.currentIntake = 0
    }
    
    // Initialize with all fields (for preview and testing)
    init(id: String, email: String, fullname: String, profileImageUrl: String? = nil,
         memberSince: Date = Date(), isPremium: Bool = false, dailyGoal: Double = 2000,currenIntake: Double = 0,
         streakDays: Int = 0, achievementsCount: Int = 0, notificationsEnabled: Bool = true,
         darkModeEnabled: Bool = false) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
        self.memberSince = memberSince
        self.isPremium = isPremium
        self.dailyGoal = dailyGoal
        self.currentIntake = currenIntake
        self.streakDays = streakDays
        self.achievementsCount = achievementsCount
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
    }
}

extension User {
    static var MOCK_USER = User(id: "1", fullname: "Tyreek Hill", email: "tyreekcheetah@gmail.com")
}
