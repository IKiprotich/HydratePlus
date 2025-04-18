//
//  WaterWaveView.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct WaterWaveView: View {
    let progress: Double
    let waveHeight: Double
    var animatablePhase: Double
    
    var body: some View {
        ZStack {
            // Fill color based on progress
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let midY = height * (1 - progress)
                
                // Background fill
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
                
                // First wave
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
                
                // Second wave (offset)
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
