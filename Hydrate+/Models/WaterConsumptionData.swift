//
//  WaterConsumptionData.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

/*
 * WaterConsumptionData.swift
 * 
 * This model represents a single water consumption entry in the Hydrate+ app.
 * It stores the essential data for tracking water intake:
 * - date: When the water was consumed
 * - amount: The quantity of water consumed (in the app's standard unit)
 * - label: A descriptive label for the consumption period
 * 
 * The model also provides utility functions for generating appropriate labels
 * based on different time frames (day, week, month) to help organize and
 * display water consumption data in various views throughout the app.
 */

import Foundation

struct WaterConsumptionData: Equatable {
    let date: Date
    let amount: Double
    let label: String
    
    // For day view and time periods
    static let dayPeriods = ["Morning", "Noon", "Afternoon", "Evening", "Night", "Late"]
    
    // Helper to create a formatted label based on date and timeframe
    static func createLabel(for date: Date, timeFrame: TimeFrame, index: Int) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        switch timeFrame {
        case .day:
            return dayPeriods[index % dayPeriods.count]
            
        case .week:
            formatter.dateFormat = "E"
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let day = calendar.date(byAdding: .day, value: index, to: weekStart)!
            return formatter.string(from: day)
            
        case .month:
            formatter.dateFormat = "d"
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            let day = calendar.date(byAdding: .day, value: index, to: monthStart)!
            return formatter.string(from: day)
        }
    }
}
