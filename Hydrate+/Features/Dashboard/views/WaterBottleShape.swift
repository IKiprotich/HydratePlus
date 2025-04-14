//
//  WaterBottleShape.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct WaterBottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Start at the top-left of the bottle cap
        path.move(to: CGPoint(x: width * 0.40, y: 0))
        
        // Top cap line
        path.addLine(to: CGPoint(x: width * 0.60, y: 0))
        
        // Smooth curve to the neck (right side)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.15),
            control: CGPoint(x: width * 0.65, y: height * 0.05)
        )
        
        // Straight-ish body with a slight outward curve (right side)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.90),
            control: CGPoint(x: width * 0.67, y: height * 0.50)
        )
        
        // Flat bottom with a slight inward curve
        path.addQuadCurve(
            to: CGPoint(x: width * 0.35, y: height * 0.90),
            control: CGPoint(x: width * 0.50, y: height * 0.95)
        )
        
        // Straight-ish body with a slight outward curve (left side)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.35, y: height * 0.15),
            control: CGPoint(x: width * 0.33, y: height * 0.50)
        )
        
        // Close with a smooth neck curve (left side)
        path.addQuadCurve(
            to: CGPoint(x: width * 0.40, y: 0),
            control: CGPoint(x: width * 0.35, y: height * 0.05)
        )
        
        return path
    }
}

#Preview {
    WaterBottleShape()
        .fill(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.3), .blue.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .frame(width: 400, height: 400)
        .shadow(radius: 5)
}
