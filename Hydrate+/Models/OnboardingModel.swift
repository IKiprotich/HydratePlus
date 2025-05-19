//
//  OnboardingModel.swift
//  Hydrate+
//
//  Created by Ian   on 19/05/2025.
//

import Foundation

struct OnboardingFeature {
    let title: String
    let description: String
    let iconName: String
}

struct UserPreferences {
    var name: String = ""
    var notificationsEnabled: Bool = false
}

enum OnboardingStep: Int, CaseIterable {
    case welcome
    case features
    case permissions
    case complete
}
