//
//  DateFormatters.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//
//

// This file contains date formatting utilities for displaying dates in different time frames
// (day, week, month) throughout the Hydrate+ app.

import Foundation

struct DateFormatters {
    static func formatTimeFrame(date: Date, timeFrame: TimeFrame) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        switch timeFrame {
        case .day:
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
            
        case .week:
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            
            formatter.dateFormat = "MMM d"
            let startString = formatter.string(from: weekStart)
            let endString = formatter.string(from: weekEnd)
            
            return "\(startString) - \(endString)"
            
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }
}
