//
//  ProgressCircle.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct ProgressCircle: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [color.opacity(0.5), color]),
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * progress)
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    ProgressCircle(progress: 0.75, color: .blue, lineWidth: 10)
        .frame(width: 200, height: 200)
}
