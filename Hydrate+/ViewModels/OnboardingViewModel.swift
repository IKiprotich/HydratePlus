//
//  OnboardingViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 19/05/2025.
//

import Foundation
import SwiftUI
import UserNotifications

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var userPreferences = UserPreferences()
    @Published var features: [OnboardingFeature] = [
        OnboardingFeature(
            title: "Track Your Intake",
            description: "Log your water intake and hit your daily goal",
            iconName: "drop.fill"
        ),
        OnboardingFeature(
            title: "Stay Consistent",
            description: "Build hydration streaks and keep your momentum going",
            iconName: "flame.fill"
        ),
        OnboardingFeature(
            title: "Smart Reminders",
            description: "Get motivational reminders when you fall behind",
            iconName: "bell.fill"
        )
    ]
    
    init() {
        // Check if onboarding has been completed
        if UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            currentStep = .complete
        }
    }
    
    func moveToNextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex < OnboardingStep.allCases.count - 1 else {
            completeOnboarding()
            return
        }
        currentStep = OnboardingStep.allCases[currentIndex + 1]
    }
    
    func completeOnboarding() {
        // Save user preferences
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.userPreferences.notificationsEnabled = granted
                if granted {
                    self.scheduleInitialReminders()
                }
            }
        }
    }
    
    private func scheduleInitialReminders() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Hydrate!"
        content.body = "Don't forget to track your water intake"
        content.sound = .default
        
        // Schedule hourly reminders
        for hour in 9...17 {
            var components = DateComponents()
            components.hour = hour
            components.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: "hydration-reminder-\(hour)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
