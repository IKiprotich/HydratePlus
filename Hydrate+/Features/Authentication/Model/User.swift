//
//  User.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullname: String
    var profileImageUrl: String?
    
    // Additional user properties with default values
    var memberSince: Date = Date()
    var isPremium: Bool = false
    var dailyGoal: Double = 2000
    var streakDays: Int = 0
    var achievementsCount: Int = 0
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    
    // Initialize with required fields only
    init(id: String, fullname: String, email: String) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.memberSince = Date()
    }
    
    // Initialize with all fields (for preview and testing)
    init(id: String, email: String, fullname: String, profileImageUrl: String? = nil,
         memberSince: Date = Date(), isPremium: Bool = false, dailyGoal: Double = 2000,
         streakDays: Int = 0, achievementsCount: Int = 0, notificationsEnabled: Bool = true,
         darkModeEnabled: Bool = false) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
        self.memberSince = memberSince
        self.isPremium = isPremium
        self.dailyGoal = dailyGoal
        self.streakDays = streakDays
        self.achievementsCount = achievementsCount
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
    }
}

extension User {
    static var MOCK_USER = User(id: "1", fullname: "Tyreek Hill", email: "tyreekcheetah@gmail.com")
}
