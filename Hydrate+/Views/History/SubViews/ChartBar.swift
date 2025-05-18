//
//  ChartBar.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A reusable bar chart component that displays water intake data in a vertical bar format.
/// This component is used in the History view to visualize daily water consumption.
///
/// The ChartBar provides a visual representation of water intake with the following features:
/// - Animated height adjustment based on the amount of water consumed
/// - Gradient-filled bar with a subtle shadow for depth
/// - Amount label above the bar
/// - Day label below the bar
struct ChartBar: View {
    /// The amount of water consumed for this bar
    let amount: Double
    
    /// The label displayed below the bar (typically a day of the week)
    let label: String
    
    /// The maximum value used to calculate the bar's relative height
    let maxValue: Double
    
    /// The maximum height the bar can reach
    let maxHeight: CGFloat
    
    /// Controls whether the bar should animate its height
    let isAnimated: Bool
    
    /// Calculates the height of the bar based on the amount relative to the maximum value
    /// Ensures a minimum height of 20 points for visibility
    private var barHeight: CGFloat {
        max(20, (amount / maxValue) * maxHeight)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            // Amount label showing the exact water intake
            Text("\(Int(amount))")
                .font(.system(size: 10))
                .foregroundStyle(Color.secondary)
                .opacity(isAnimated ? 1 : 0)
            
            // Main bar visualization
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.7),
                            Color.blue
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: isAnimated ? barHeight : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.blue.opacity(0.2), radius: 2, x: 0, y: 2)
            
            // Day label
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 30)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ChartBar(
        amount: 1500,
        label: "Mon",
        maxValue: 2000,
        maxHeight: 200,
        isAnimated: true
    )
    .frame(width: 60)
    .padding()
}
