//
//  HistoryListItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct HistoryListItem: View {
    let item: HistoryItem
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.formattedDate)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    
                    Text("\(item.formattedAmount) • \(item.progress)% of daily goal")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                
                Spacer()
                
                // Circular progress indicator
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(Double(item.progress) / 100))
                        .stroke(
                            getProgressColor(progress: item.progress),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 44, height: 44)
                    
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
    .previewLayout(.sizeThatFits)
}
