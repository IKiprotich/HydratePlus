//
//  StatsSection.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct StatsSection: View {
    let streak: Int
    let dailyAverage: String
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "flame.fill",
                value: "\(streak)",
                label: "Day Streak",
                color: .orange
            )
            
            StatCard(
                icon: "chart.bar.fill",
                value: dailyAverage,
                label: "Daily Avg",
                color: .blue
            )
        }
    }
}

#Preview {
    StatsSection(streak: 7, dailyAverage: "1.8L")
        .padding()
}
