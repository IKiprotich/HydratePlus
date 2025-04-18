//
//  SampleData.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import Foundation



// Fixed: Made this a class with static methods for easier access
class SampleData {
    static func getSampleWaterLogs() -> [WaterLog] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            WaterLog(amount: 250, time: calendar.date(byAdding: .hour, value: -5, to: now) ?? now),
            WaterLog(amount: 500, time: calendar.date(byAdding: .hour, value: -3, to: now) ?? now),
            WaterLog(amount: 350, time: calendar.date(byAdding: .hour, value: -1, to: now) ?? now)
        ]
    }
}


