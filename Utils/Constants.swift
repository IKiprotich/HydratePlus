//
//  Constants.swift
//  Hydrate+
//
//  Created by Ian on 11/04/2025.
//

import SwiftUI

/// Constants used throughout the app
enum Constants {
    // MARK: - UI Constants
    
    enum UI {
        /// Default corner radius for cards and buttons
        static let cornerRadius: CGFloat = 16
        
        /// Default padding for content
        static let defaultPadding: CGFloat = 20
        
        /// Default animation duration
        static let animationDuration: Double = 0.3
        
        /// Default shadow radius
        static let shadowRadius: CGFloat = 10
    }
    
    // MARK: - Water Constants
    
    enum Water {
        /// Default daily water goal in milliliters
        static let defaultDailyGoal: Double = 2000
        
        /// Minimum water amount that can be logged
        static let minimumAmount: Double = 50
        
        /// Maximum water amount that can be logged in one entry
        static let maximumAmount: Double = 5000
        
        /// Common water amounts for quick add
        static let quickAddAmounts: [Double] = [100, 250, 330, 500, 750, 1000]
    }
    
    // MARK: - Time Constants
    
    enum Time {
        /// Default reminder interval in minutes
        static let defaultReminderInterval: TimeInterval = 60 * 60 // 1 hour
        
        /// Maximum reminder interval in minutes
        static let maximumReminderInterval: TimeInterval = 60 * 60 * 4 // 4 hours
        
        /// Minimum reminder interval in minutes
        static let minimumReminderInterval: TimeInterval = 60 * 15 // 15 minutes
    }
    
    // MARK: - Firebase Constants
    
    enum Firebase {
        /// Collection names
        enum Collections {
            static let users = "users"
            static let waterLogs = "waterLogs"
            static let notifications = "notifications"
        }
        
        /// Field names
        enum Fields {
            static let date = "date"
            static let time = "time"
            static let amount = "amount"
            static let isRead = "isRead"
            static let timestamp = "timestamp"
        }
    }
} 