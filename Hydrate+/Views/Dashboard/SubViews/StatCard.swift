//
//  StatCard.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A reusable card component that displays a statistic with an icon, value, and label.
///
/// The StatCard is designed to present key metrics in a visually appealing way, commonly used
/// in the dashboard to show important statistics like water intake, streaks, or goals.
///
/// Example usage:
/// ```swift
/// StatCard(
///     icon: "flame.fill",
///     value: "7",
///     label: "Day Streak",
///     color: .orange
/// )
/// ```
struct StatCard: View {
    /// The SF Symbol name for the icon to display
    let icon: String
    
    /// The main value to display (e.g., "7" for a 7-day streak)
    let value: String
    
    /// The descriptive label for the statistic (e.g., "Day Streak")
    let label: String
    
    /// The accent color used for the icon and its background
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon container with background
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Text content stack
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.primary)
                
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        // Card container with shadow and rounded corners
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 3)
        )
    }
}

#Preview {
    StatCard(icon: "flame.fill", value: "7", label: "Day Streak", color: .orange)
        .padding()
}
