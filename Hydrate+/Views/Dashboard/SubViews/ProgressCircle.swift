//
//  ProgressCircle.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A circular progress indicator view that displays hydration progress with customizable styling and center content.
///
/// This view creates a circular progress indicator that is used in the Hydrate+ app to visualize
/// the user's daily water intake progress. The circle's color changes based on the progress percentage,
/// providing visual feedback about the user's hydration status.
///
/// The view consists of:
/// - A background circle showing the total progress track
/// - A foreground circle that fills based on the current progress
/// - Customizable center content to display additional information
struct ProgressCircleView: View {
    /// The current progress value as a percentage (0-100)
    let progress: Int
    
    /// The overall size of the circular progress indicator
    let size: CGFloat
    
    /// The width of the progress circle's stroke
    let lineWidth: CGFloat
    
    /// The content to be displayed in the center of the circle
    let centerContent: AnyView
    
    /// Creates a new progress circle view with the specified parameters
    /// - Parameters:
    ///   - progress: The current progress value (0-100)
    ///   - size: The overall size of the circle
    ///   - lineWidth: The width of the circle's stroke
    ///   - centerContent: A view builder closure that creates the content to display in the center
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
    
    /// Determines the color of the progress indicator based on the current progress
    ///
    /// - Red: Progress < 50%
    /// - Orange: Progress between 50% and 80%
    /// - Blue: Progress >= 80%
    private var progressColor: Color {
        if progress < 50 {
            return .red
        } else if progress < 80 {
            return .orange
        } else {
            return Color.blue
        }
    }
    
    /// Converts the progress percentage to a fraction (0.0 to 1.0) for the circle's trim
    private var progressFraction: CGFloat {
        CGFloat(Double(progress) / 100)
    }
    
    var body: some View {
        ZStack {
            // Background circle showing the total progress track
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Foreground circle that fills based on current progress
            Circle()
                .trim(from: 0, to: progressFraction)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Rotate to start from top
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            // Center content (e.g., current water intake and percentage)
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
