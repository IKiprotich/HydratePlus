//
//  WaterWaveView.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A custom SwiftUI view that creates an animated water wave effect to visualize progress.
/// This view is used in the Hydrate+ app to represent water levels in a visually appealing way.
///
/// The view combines multiple layers:
/// 1. A gradient background that fills based on progress
/// 2. Two animated wave patterns that create a realistic water effect
/// 3. Smooth animations that respond to progress changes
struct WaterWaveView: View {
    /// The progress value between 0 and 1 representing the water level
    let progress: Double
    
    /// The height of the wave animation
    let waveHeight: Double
    
    /// The animation phase that controls the wave movement
    var animatablePhase: Double
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let midY = height * (1 - progress)
                
                // Background gradient that fills based on progress
                // Creates a smooth transition from darker to lighter blue
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.7),
                                Color.blue.opacity(0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: width, height: height * progress)
                    .position(x: width / 2, y: height - (height * progress) / 2)
                
                // First wave pattern - creates the main water surface effect
                // Uses a sine wave function to generate the wave pattern
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    
                    for x in stride(from: 0, to: width, by: 1) {
                        let relativeX = x / 50
                        let sine = sin(relativeX + animatablePhase * 2 * .pi)
                        let y = midY + sine * waveHeight
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.7))
                
                // Second wave pattern - creates depth and movement
                // Uses a different frequency and phase offset for a more complex water effect
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    
                    for x in stride(from: 0, to: width, by: 1) {
                        let relativeX = x / 40
                        let sine = sin(relativeX + animatablePhase * 2 * .pi + 1)
                        let y = midY + sine * waveHeight * 0.7
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.3))
            }
        }
    }
}

#Preview {
    WaterWaveView(progress: 0.7, waveHeight: 5, animatablePhase: 0.5)
        .frame(width: 200, height: 200)
        .clipShape(Circle())
}

