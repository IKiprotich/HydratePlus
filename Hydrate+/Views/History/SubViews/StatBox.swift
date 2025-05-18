//
//  StatBox.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A reusable view component that displays a statistic with an icon, value, and title.
///
/// The StatBox is designed to present individual statistics in a visually appealing card format.
/// It's commonly used throughout the app to display various hydration-related metrics such as
/// daily goals, current intake, or historical data.
///
/// The component features:
/// - A customizable icon from SF Symbols
/// - A prominent value display
/// - A descriptive title
/// - A subtle background color that matches the icon
///
/// Example usage:
/// ```swift
/// StatBox(
///     title: "Daily Goal",
///     value: "2000ml",
///     icon: "target",
///     color: .purple
/// )
/// ```
struct StatBox: View {
    /// The title displayed below the value (e.g., "Goal", "Intake", "Remaining")
    let title: String
    
    /// The main value to be displayed (e.g., "2000ml", "75%")
    let value: String
    
    /// The SF Symbol name for the icon to be displayed
    let icon: String
    
    /// The color theme for the icon and background
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon display with consistent sizing and color
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            // Main value display with bold styling
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.primary)
            
            // Title display with secondary styling
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            // Subtle background with rounded corners
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    StatBox(
        title: "Goal",
        value: "2000ml",
        icon: "target",
        color: .purple
    )
    .frame(width: 150)
    .padding()
}
