//
//  HistoryDataService.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import Foundation

class HistoryDataService {

    static func getConsumptionData(for date: Date, timeFrame: TimeFrame) -> [WaterConsumptionData] {
        let calendar = Calendar.current
        var result: [WaterConsumptionData] = []
        
        switch timeFrame {
        case .day:
            // For day view, we show 6 time periods
            for i in 0..<6 {
                let periodLabel = WaterConsumptionData.dayPeriods[i]
    
                var amount: Double
                switch i {
                case 0: amount = Double.random(in: 200...400) // Morning
                case 1: amount = Double.random(in: 300...500) // Noon
                case 2: amount = Double.random(in: 200...350) // Afternoon
                case 3: amount = Double.random(in: 250...450) // Evening
                case 4: amount = Double.random(in: 100...300) // Night
                case 5: amount = Double.random(in: 0...150)   // Late
                default: amount = 0
                }
                
                result.append(WaterConsumptionData(
                    date: date,
                    amount: amount,
                    label: periodLabel
                ))
            }
            
        case .week:
            // For week view, we show 7 days
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            
            for i in 0..<7 {
                let day = calendar.date(byAdding: .day, value: i, to: weekStart)!
                let label = WaterConsumptionData.createLabel(for: date, timeFrame: .week, index: i)
                let isWeekend = calendar.isDateInWeekend(day)
                let amount = isWeekend ?
                    Double.random(in: 1400...2200) :
                    Double.random(in: 1600...2400)
                
                result.append(WaterConsumptionData(
                    date: day,
                    amount: amount,
                    label: label
                ))
            }
            
        case .month:
            // For month view, we show days in the month
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 30
            
            for i in 0..<daysInMonth {
                let day = calendar.date(byAdding: .day, value: i, to: monthStart)!
                let label = WaterConsumptionData.createLabel(for: date, timeFrame: .month, index: i)
                let isWeekend = calendar.isDateInWeekend(day)
                let weekdayFactor = isWeekend ? 0.9 : 1.1
                let dayOfMonthFactor = 1.0 + (Double(i % 7) / 20.0) // Small cycle through the week
                
                let amount = 1800.0 * weekdayFactor * dayOfMonthFactor * Double.random(in: 0.85...1.15)
                
                result.append(WaterConsumptionData(
                    date: day,
                    amount: amount,
                    label: label
                ))
            }
        }
        
        return result
    }
    
    static func getHistoryItems(count: Int = 7, dailyGoal: Double = 2000) -> [HistoryItem] {
        let calendar = Calendar.current
        var items: [HistoryItem] = []
        
        for i in 0..<count {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let isWeekend = calendar.isDateInWeekend(date)
            let weekdayFactor = isWeekend ? 0.9 : 1.1
            let randomFactor = Double.random(in: 0.85...1.15)
            
            let amount = 1800.0 * weekdayFactor * randomFactor
            
            items.append(HistoryItem(
                date: date,
                totalAmount: amount,
                dailyGoal: dailyGoal
            ))
        }
        
        return items
    }
}
