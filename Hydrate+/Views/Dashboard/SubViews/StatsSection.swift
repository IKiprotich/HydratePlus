//
//  StatsSection.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A view component that displays key hydration statistics in a card-like format.
///
/// This view is designed to show two important metrics:
/// 1. The user's current streak of consecutive days meeting their hydration goals
/// 2. The user's daily average water intake
///
/// The view presents these statistics in a visually appealing card with a clean, modern design
/// that includes a subtle shadow and rounded corners. The statistics are separated by a
/// vertical divider for clear visual distinction.
struct StatsSection: View {
    /// The number of consecutive days the user has met their hydration goals
    let streak: Int
    
    /// The average amount of water (in milliliters) the user consumes daily
    let dailyAverage: Double
    
    var body: some View {
        // Main container that holds both statistics
        HStack(spacing: 24) {
            // Streak statistics container
            VStack {
                Text("\(streak)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
                
                Text("Day Streak")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            // Visual separator between statistics
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 30)
            
            // Daily average statistics container
            VStack {
                Text("\(Int(dailyAverage))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
                
                Text("Daily Average")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        // Card-like appearance with shadow and rounded corners
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    StatsSection(streak: 3, dailyAverage: 1850)
}
