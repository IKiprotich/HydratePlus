//
//  HistoryItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import Foundation

struct HistoryItem: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let totalAmount: Double
    let dailyGoal: Double
    
    var progress: Int {
        Int(min(totalAmount / dailyGoal * 100, 100))
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        "\(Int(totalAmount)) ml"
    }
}
