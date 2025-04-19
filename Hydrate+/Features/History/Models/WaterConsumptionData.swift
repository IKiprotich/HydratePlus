//
//  WaterConsumptionData.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import Foundation

struct WaterConsumptionData: Equatable {
    let date: Date
    let amount: Double
    let label: String
    
    // For day view - time periods
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
