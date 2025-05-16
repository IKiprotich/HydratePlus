//
//  RoundedCorrners.swift
//  Hydrate+
//
//  Created by Ian   on 05/05/2025.
//

/*
 * RoundedCorner is a custom SwiftUI Shape that allows for creating views with selectively rounded corners.
 * It provides flexibility to round specific corners of a view while leaving others square.
 * 
 * Usage:
 * - radius: Controls the corner radius (defaults to infinity for maximum rounding)
 * - corners: Specifies which corners to round using UIRectCorner options
 * 
 * Example:
 * RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
 */

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
