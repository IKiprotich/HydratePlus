//
//  CircleWaveView.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//
import SwiftUI

struct CircleWaveView: View {
    @State private var waveOffset = Angle(degrees: 0)
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.blue.opacity(0.7 - Double(i) * 0.2),
                            lineWidth: 20 - CGFloat(i) * 4
                        )
                        .rotationEffect(Angle(degrees: 270))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
