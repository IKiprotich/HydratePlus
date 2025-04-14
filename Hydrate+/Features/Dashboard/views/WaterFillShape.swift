//
//  WaterFillShape.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct WaterFillShape: Shape {
    var fillLevel: CGFloat
    
    var animatableData: CGFloat {
        get { fillLevel }
        set { fillLevel = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let adjustedFillLevel = max(0, min(fillLevel, 1))
        let waterHeight = height * adjustedFillLevel
        let startY = height - waterHeight
        
        var path = Path()
        path.move(to: CGPoint(x: width * 0.1, y: height))
        path.addLine(to: CGPoint(x: width * 0.9, y: height))
        path.addLine(to: CGPoint(x: width * 0.9, y: startY))
        path.addLine(to: CGPoint(x: width * 0.1, y: startY))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    WaterFillShape(fillLevel: 60)
}
