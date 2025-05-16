//
//  NotificationCardView.swift
//  Hydrate+
//
//  Created by Ian   on 02/05/2025.
//

import SwiftUI

struct NotificationCardView: View {
    @ObservedObject var notificationService: NotificationService
    @State private var selectedNotification: HydrateNotification?
    @State private var showNotificationDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Notifications")
                    .font(.headline)
                
                Spacer()
                
                if !notificationService.notifications.isEmpty {
                    Button {
                        Task {
                            try? await notificationService.markAllAsRead()
                        }
                    } label: {
                        Text("Mark all as read")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding(.bottom, 4)
            
            Divider()
            
            if notificationService.notifications.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 24))
                        .foregroundStyle(.secondary)
                    
                    Text("No notifications")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(notificationService.notifications) { notification in
                            NotificationItem(notification: notification)
                                .onTapGesture {
                                    selectedNotification = notification
                                    showNotificationDetail = true
                                    
                                    if !notification.isRead {
                                        Task {
                                            try? await notificationService.markAsRead(notificationId: notification.id ?? "")
                                        }
                                    }
                                }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .frame(width: 300)
        .background(.ultraThinMaterial.opacity(0.9))
        .cornerRadius(14)
        .shadow(radius: 12)
        .sheet(isPresented: $showNotificationDetail) {
            if let notification = selectedNotification {
                NotificationDetailView(notification: notification)
            }
        }
    }
}

struct NotificationItem: View {
    let notification: HydrateNotification
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(notification.type.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(notification.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text(notification.timestamp.formatted(.relative(presentation: .named)))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if !notification.isRead {
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NotificationDetailView: View {
    let notification: HydrateNotification
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(notification.type.icon)
                    .font(.system(size: 48))
                
                Text(notification.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(notification.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Text(notification.timestamp.formatted(date: .long, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

