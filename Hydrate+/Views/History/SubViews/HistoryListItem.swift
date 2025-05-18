//
//  HistoryListItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A view component that displays a single history item in the app's history list.
/// This component shows the date, water intake amount, and progress towards the daily goal
/// in a visually appealing format with a circular progress indicator.
struct HistoryListItem: View {
    /// The history item containing the data to be displayed
    let item: HistoryItem
    
    /// Optional closure that gets called when the item is tapped
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack {
                // Left side: Date and progress information
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.formattedDate)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    
                    Text("\(item.formattedAmount) • \(item.progress)% of daily goal")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                
                Spacer()
                
                // Right side: Circular progress indicator
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0, to: CGFloat(Double(item.progress) / 100))
                        .stroke(
                            getProgressColor(progress: item.progress),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 44, height: 44)
                    
                    // Progress percentage text
                    Text("\(item.progress)%")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(getProgressColor(progress: item.progress))
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Determines the color of the progress indicator based on the progress percentage
    /// - Parameter progress: The progress percentage (0-100)
    /// - Returns: A Color that represents the progress level:
    ///   - Red: < 50% progress
    ///   - Orange: 50-79% progress
    ///   - Blue: ≥ 80% progress
    private func getProgressColor(progress: Int) -> Color {
        if progress < 50 {
            return .red
        } else if progress < 80 {
            return .orange
        } else {
            return Color.blue
        }
    }
}

#Preview {
    HistoryListItem(
        item: HistoryItem(
            date: Date(),
            totalAmount: 1800,
            dailyGoal: 2000
        )
    )
    .padding()
}
