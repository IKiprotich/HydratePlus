//
//  NotificationService.swift
//  Hydrate+
//
//  Created by Ian on 11/04/2025.
//

import Foundation
import FirebaseFirestore
import UserNotifications

/// Service responsible for managing notifications and reminders
class NotificationService: ObservableObject {
    // MARK: - Published Properties
    
    /// List of notifications for the current user
    @Published var notifications: [HydrateNotification] = []
    
    /// Count of unread notifications
    @Published var unreadCount: Int = 0
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    private let userID: String
    
    // MARK: - Initialization
    
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
        setupNotificationCenter()
    }
    
    // MARK: - Public Methods
    
    /// Fetches notifications for the current user
    @MainActor
    func fetchNotifications() async throws {
        let snapshot = try await db.collection("users")
            .document(userID)
            .collection("notifications")
            .order(by: "timestamp", descending: true)
            .limit(to: 50)
            .getDocuments()
        
        notifications = snapshot.documents.compactMap { document in
            try? document.data(as: HydrateNotification.self)
        }
        
        updateUnreadCount()
    }
    
    /// Marks a notification as read
    /// - Parameter notificationId: ID of the notification to mark as read
    @MainActor
    func markAsRead(notificationId: String) async throws {
        try await db.collection("users")
            .document(userID)
            .collection("notifications")
            .document(notificationId)
            .updateData(["isRead": true])
        
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
            updateUnreadCount()
        }
    }
    
    /// Marks all notifications as read
    @MainActor
    func markAllAsRead() async throws {
        let batch = db.batch()
        
        for notification in notifications where !notification.isRead {
            guard let id = notification.id else { continue }
            let ref = db.collection("users")
                .document(userID)
                .collection("notifications")
                .document(id)
            batch.updateData(["isRead": true], forDocument: ref)
        }
        
        try await batch.commit()
        
        notifications = notifications.map { notification in
            var updated = notification
            updated.isRead = true
            return updated
        }
        
        updateUnreadCount()
    }
    
    /// Schedules a local notification
    /// - Parameters:
    ///   - title: Notification title
    ///   - body: Notification body
    ///   - timeInterval: Time interval until notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Private Methods
    
    private func setupNotificationCenter() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
    
    private func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.isRead }.count
    }
} 