//
//  NotificationService.swift
//  Hydrate+
//
//  Created by Ian   on 14/05/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotificationService: ObservableObject {
    private let db = Firestore.firestore()
    @Published var notifications: [HydrateNotification] = []
    @Published var unreadCount: Int = 0
    
    @MainActor
    func fetchNotifications() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "NotificationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("notifications")
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
            .getDocuments()
        
        self.notifications = snapshot.documents.compactMap { doc in
            try? doc.data(as: HydrateNotification.self)
        }
        
       
        self.unreadCount = notifications.filter { !$0.isRead }.count
    }
    
    func markAsRead(notificationId: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "NotificationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        try await db.collection("users")
            .document(userId)
            .collection("notifications")
            .document(notificationId)
            .updateData(["isRead": true])
        
        // Update local state
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
            unreadCount = notifications.filter { !$0.isRead }.count
        }
    }
    
    func markAllAsRead() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "NotificationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let batch = db.batch()
        let unreadNotifications = notifications.filter { !$0.isRead }
        
        for notification in unreadNotifications {
            guard let id = notification.id else { continue }
            let ref = db.collection("users")
                .document(userId)
                .collection("notifications")
                .document(id)
            batch.updateData(["isRead": true], forDocument: ref)
        }
        
        try await batch.commit()
        
        // Update local state
        notifications = notifications.map { notification in
            var updated = notification
            updated.isRead = true
            return updated
        }
        unreadCount = 0
    }
    
    func createNotification(title: String, message: String, type: NotificationType) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "NotificationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let notification = HydrateNotification(
            title: title,
            message: message,
            type: type
        )
        
        let ref = try await db.collection("users")
            .document(userId)
            .collection("notifications")
            .addDocument(from: notification)
        
        // Update local state
        var updatedNotification = notification
        updatedNotification.id = ref.documentID
        notifications.insert(updatedNotification, at: 0)
        unreadCount += 1
    }
}
