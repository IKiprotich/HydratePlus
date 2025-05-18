//
//  GreetingHeader.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A view component that displays a personalized greeting header in the dashboard.
///
/// The `GreetingHeader` serves as the welcoming element at the top of the dashboard,
/// providing a personalized greeting to the user and a motivational message about
/// tracking water intake. This component helps create a friendly and engaging user
/// experience while maintaining a clean and modern design.
///
/// The header consists of two text elements:
/// 1. A personalized greeting that uses the user's name if available
/// 2. A subtitle encouraging water intake tracking
struct GreetingHeader: View {
    /// The user's name to be displayed in the greeting.
    /// If nil, defaults to "Hydration Hero" as a friendly fallback.
    let name: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Main greeting text with the user's name
            Text("Hello, \(name ?? "Hydration Hero")!")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.deepBlue)
            
            // Motivational subtitle
            Text("Let's track your water intake today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GreetingHeader(name: "Kanye")
        .padding()
}
