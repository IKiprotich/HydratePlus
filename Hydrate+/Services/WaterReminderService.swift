//
//  WaterReminderService.swift
//  Hydrate+
//
//  Created by Ian   on 14/05/2025.
//

import Foundation
import UserNotifications
import FirebaseFirestore
import FirebaseAuth

class WaterReminderService: ObservableObject {
    private let db = Firestore.firestore()
    private let notificationCenter = UNUserNotificationCenter.current()
    private var reminderTimer: Timer?
    
    // Motivational messages to randomize
    private let motivationalMessages = [
        "🚰 Time to hydrate! Your body will thank you.",
        "💧 Stay on track — drink a glass of water now!",
        "🌟 Don't lose your streak! Keep sipping!",
        "🏆 Hydrate to dominate your day!",
        "💪 Every sip counts towards your goal!",
        "🌊 Make waves with your hydration!",
        "✨ Stay refreshed, stay focused!",
        "🎯 You're closer than you think to your goal!"
    ]
    
    init() {
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func startHourlyReminders() {
        // Cancel any existing reminders
        stopHourlyReminders()
        
        // Schedule new reminders
        reminderTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            Task {
                await self?.checkAndSendReminder()
            }
        }
        
        // Trigger first check immediately
        Task {
            await checkAndSendReminder()
        }
    }
    
    func stopHourlyReminders() {
        reminderTimer?.invalidate()
        reminderTimer = nil
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func checkAndSendReminder() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Get user's daily goal and current intake
            let userDoc = try await db.collection("users").document(userId).getDocument()
            guard let userData = userDoc.data(),
                  let dailyGoal = userData["dailyGoal"] as? Double,
                  let currentIntake = userData["currentIntake"] as? Double,
                  let firstName = userData["firstName"] as? String else {
                return
            }
            
            // Check if user hasn't reached their goal
            if currentIntake < dailyGoal {
                let remainingAmount = dailyGoal - currentIntake
                let message = generateReminderMessage(firstName: firstName, remainingAmount: remainingAmount)
                
                // Create and schedule notification
                let content = UNMutableNotificationContent()
                content.title = "Time to Hydrate! 💧"
                content.body = message
                content.sound = .default
                
                // Create trigger for immediate delivery
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                // Create request
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                // Schedule notification
                try await notificationCenter.add(request)
            }
        } catch {
            print("Error checking and sending reminder: \(error.localizedDescription)")
        }
    }
    
    private func generateReminderMessage(firstName: String, remainingAmount: Double) -> String {
        let randomMessage = motivationalMessages.randomElement() ?? motivationalMessages[0]
        let formattedAmount = String(format: "%.0f", remainingAmount)
        return "Hey \(firstName)! \(randomMessage) Only \(formattedAmount)ml left to reach your goal!"
    }
    
    // Call this when user reaches their daily goal
    func cancelRemindersForToday() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
