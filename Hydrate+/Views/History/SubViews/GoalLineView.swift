//
//  GoalLineView.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A view that displays a horizontal goal line indicator in the hydration tracking chart.
///
/// This view is used to show the user's daily water intake goal as a reference line in the history chart.
/// It consists of a vertical red line with a "Goal" label, positioned at the appropriate height based on
/// the goal value relative to the maximum value in the chart.
///
/// The view is designed to be overlaid on top of the main chart view, providing a visual reference
/// for users to compare their actual water intake against their daily goal.
struct GoalLineView: View {
    /// The target water intake goal value in milliliters
    let goalValue: Double
    
    /// The maximum value shown in the chart (used for scaling)
    let maxValue: Double
    
    /// The maximum height of the chart in points
    let maxHeight: CGFloat
    
    /// Calculates the vertical offset for the goal line based on the goal value's position
    /// relative to the maximum value in the chart.
    ///
    /// The offset is calculated to position the line at the correct height where the goal value
    /// would appear on the chart's scale.
    private var offsetY: CGFloat {
        -((goalValue / maxValue) * maxHeight - maxHeight) / 2
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // A vertical line indicator for the goal
            Rectangle()
                .fill(Color.red.opacity(0.2))
                .frame(width: 4)
            
            // Label indicating this is the goal line
            Text(" Goal")
                .font(.caption)
                .foregroundStyle(Color.red.opacity(0.7))
                .padding(.leading, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .offset(y: offsetY)
    }
}

#Preview {
    GoalLineView(goalValue: 2000, maxValue: 3000, maxHeight: 200)
        .frame(height: 200)
        .background(Color.gray.opacity(0.1))
}
