//
//  Color+Extension.swift
//  Hydrate+
//
//  Created by Ian on 11/04/2025.
//

import SwiftUI

extension Color {
    /// Custom colors used throughout the app
    static let deepBlue = Color("DeepBlue")
    static let lightBlue = Color("LightBlue")
    static let accentBlue = Color("AccentBlue")
    
    /// Progress colors based on percentage
    static func progressColor(for percentage: Double) -> Color {
        switch percentage {
        case 0..<0.5:
            return .red
        case 0.5..<0.8:
            return .orange
        default:
            return .blue
        }
    }
    
    /// Background gradient colors
    static var backgroundGradient: [Color] {
        [
            lightBlue.opacity(0.3),
            .white,
            lightBlue.opacity(0.2)
        ]
    }
} 