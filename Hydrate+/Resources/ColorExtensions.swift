
//
//  ColorExtensions.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

/*
 * ColorExtensions.swift
 * 
 * A Swift extension that defines custom colors used throughout the Hydrate+ app.
 * This file contains color definitions for:
 * - Water-related colors (waterBlue, deepBlue, lightBlue)
 * - Status indicator colors (validGreen, warningOrange, errorRed)
 * 
 * These colors are used to maintain consistent theming and visual feedback
 * across the application's user interface.
 */


import SwiftUI

extension Color {
    static let waterBlue = Color(red: 0.0, green: 0.48, blue: 0.8)
    static let deepBlue = Color(red: 0.0, green: 0.32, blue: 0.6)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    
        static let validGreen = Color.green
        static let warningOrange = Color.orange
        static let errorRed = Color.red
}
