//
//  ProgressCircle.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct ProgressCircleView: View {
    let progress: Int
    let size: CGFloat
    let lineWidth: CGFloat
    let centerContent: AnyView
    
    init(
        progress: Int,
        size: CGFloat,
        lineWidth: CGFloat,
        @ViewBuilder centerContent: @escaping () -> some View
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.centerContent = AnyView(centerContent())
    }
    
    private var progressColor: Color {
        if progress < 50 {
            return .red
        } else if progress < 80 {
            return .orange
        } else {
            return Color.blue
        }
    }
    
    private var progressFraction: CGFloat {
        CGFloat(Double(progress) / 100)
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progressFraction)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            // Center content
            centerContent
        }
    }
}

#Preview {
    ProgressCircleView(
        progress: 75,
        size: 160,
        lineWidth: 12
    ) {
        VStack(spacing: 4) {
            Text("1500ml")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text("75% of goal")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }
}
