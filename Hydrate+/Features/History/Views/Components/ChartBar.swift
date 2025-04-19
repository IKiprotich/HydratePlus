//
//  ChartBar.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct ChartBar: View {
    let amount: Double
    let label: String
    let maxValue: Double
    let maxHeight: CGFloat
    let isAnimated: Bool
    
    private var barHeight: CGFloat {
        max(20, (amount / maxValue) * maxHeight)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            // Amount label
            Text("\(Int(amount))")
                .font(.system(size: 10))
                .foregroundStyle(Color.secondary)
                .opacity(isAnimated ? 1 : 0)
            
            // Bar
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
            
            // Day/date label
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
    .previewLayout(.sizeThatFits)
}
