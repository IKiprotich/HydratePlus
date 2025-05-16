//
//  TimeFrame.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import Foundation

/*
 * TimeFrame represents the different time periods for tracking and displaying hydration data in Hydrate+.
 * It provides functionality for:
 * - Day: Shows hourly water intake for the current day
 * - Week: Displays daily water intake for the past week
 * - Month: Shows daily water intake for the current month
 *
 * Each time frame includes:
 * - A corresponding Calendar.Component for date calculations
 * - The number of bars to display in charts/visualizations
 */

enum TimeFrame: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    var id: String { self.rawValue }
    
    var dateComponent: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        }
    }
    
    var barCount: Int {
        switch self {
        case .day: return 6
        case .week: return 7 
        case .month: return min(Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30, 31)
        }
    }
}
