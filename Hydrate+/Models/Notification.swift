//
//  Notification.swift
//  Hydrate+
//
//  Created by Ian   on 14/05/2025.
//

import Foundation
import FirebaseFirestore

struct HydrateNotification: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let message: String
    let type: NotificationType
    let timestamp: Date
    var isRead: Bool
    
    init(title: String, message: String, type: NotificationType, timestamp: Date = Date(), isRead: Bool = false) {
        self.title = title
        self.message = message
        self.type = type
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

enum NotificationType: String, Codable {
    case achievement
    case reminder
    case milestone
    case system
    
    var icon: String {
        switch self {
        case .achievement: return "🏆"
        case .reminder: return "💧"
        case .milestone: return "🎯"
        case .system: return "ℹ️"
        }
    }
    
    var color: String {
        switch self {
        case .achievement: return "gold"
        case .reminder: return "blue"
        case .milestone: return "purple"
        case .system: return "gray"
        }
    }
}
